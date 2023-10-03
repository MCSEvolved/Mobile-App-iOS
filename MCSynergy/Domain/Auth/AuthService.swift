//
//  Created by Josian van Efferen on 22/05/2023.
//

import Foundation
import Firebase
import SwiftUI
import AuthenticationServices
import CryptoKit


enum AuthException: Error {
    case authServerException(responseCode: Int, error: String)
    case urlIsNilException
    case signInException(error: String)
}



enum UserRole {
    case Admin
    case Player
    case Guest
    case Unauthorized
}

extension AuthService: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
            
            // Retrieve the secure nonce generated during Apple sign in
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }

            // Retrieve Apple identity token
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Failed to fetch identity token")
                return
            }

            // Convert Apple identity token to string
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Failed to decode identity token")
                return
            }

            // Initialize a Firebase credential using secure nonce and Apple identity token
            let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: firebaseCredential) { _authResult, error in
                if (error != nil) {
                    print("1. Apple SignIn Error: \(String(describing: error?.localizedDescription))")
                    return
                }
                Task {
                    do {
                        let shouldRefreshToken: Bool = try await self.checkRoles(idToken: Auth.auth().currentUser!.getIDToken())
                        if (shouldRefreshToken) {
                            _ = try await AuthService.getToken(forceRefresh: true)
                        }
                        return
                    } catch {
                        return
                    }

                }
                
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
    
    private func performAppleSignIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        // Generate nonce for validation after authentication successful
        self.currentNonce = randomNonceString()
        // Set the SHA256 hashed nonce to ASAuthorizationAppleIDRequest
        request.nonce = sha256(currentNonce!)

        // Present Apple authorization form
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        //authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}


class AuthService: NSObject {
    private var provider: OAuthProvider?
    private let baseUrl: String = "https://api.mcsynergy.nl"
    private var currentNonce: String?
    
    static var role: UserRole = .Unauthorized
    
    
    private func checkRoles(idToken: String) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            guard let requestUrl = URL(string:"\(baseUrl)/auth/check-new-user") else {
                continuation.resume(throwing: AuthException.urlIsNilException)
                return
            }
            
            var request = URLRequest(url: requestUrl)
            
            request.httpMethod = "POST"
            
            request.setValue(idToken, forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) {data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(error!.localizedDescription)")
                    let response = response as! HTTPURLResponse
                    continuation.resume(throwing: AuthException.authServerException(responseCode: response.statusCode, error: error!.localizedDescription))
                    return
                }
                let response = response as! HTTPURLResponse
                if (response.statusCode > 299) {
                    continuation.resume(throwing: AuthException.authServerException(responseCode: response.statusCode, error: response.description))
                    return
                }
                do {
                    let responseModel: CheckRolesResponse = try JSONDecoder().decode(CheckRolesResponse.self, from: data)
                    print("SHOULD REFRESH: \(responseModel.shouldRefreshToken)")
                    continuation.resume(returning: responseModel.shouldRefreshToken)
                    return
                } catch {
                    continuation.resume(throwing: AuthException.authServerException(responseCode: 500, error: "Unable to decode response from MCS-Auth-Server"))
                    return
                }
                
                
            }
            task.resume()
        }
    }
    
    func signIn(completion: @escaping (Bool, Error?) -> Void) {
        provider = OAuthProvider(providerID: "microsoft.com")
        guard let provider = provider else {
            print("ERROR: No provider found!")
            completion(false, AuthException.signInException(error: "Unable to get provider"))
            return
        }
        provider.customParameters = [
            "prompt": "select_account"
        ]
        provider.getCredentialWith(_:nil) { credential, error in
            guard error == nil else {
                print("ERROR: \(String(describing: error!.localizedDescription))")
                completion(false, AuthException.signInException(error: error!.localizedDescription))
                return
            }
            guard let credential = credential else {
                completion(false, AuthException.signInException(error: "Unable to get credentials from provider"))
                return
            }

            Auth.auth().signIn(with: credential) { _authResult, error in
                if (error != nil) {
                    print("ERROR: \(String(describing: error?.localizedDescription))")
                    completion(false, AuthException.signInException(error: error!.localizedDescription))
                    return
                }
                Task {
                    do {
                        let shouldRefreshToken: Bool = try await self.checkRoles(idToken: Auth.auth().currentUser!.getIDToken())
                        if (shouldRefreshToken) {
                            _ = try await AuthService.getToken(forceRefresh: true)
                        }
                        completion(true, nil)
                        return
                    } catch {
                        completion(false, error)
                        return
                    }

                }
                
            }
        }
    }
    
    func signInWithApple() {
        performAppleSignIn()
    }
    
    func signInAsAnonymous() async -> Bool {
        do {
            try await Auth.auth().signInAnonymously()
            let token = try await Auth.auth().currentUser!.getIDToken()
            let shouldRefreshToken: Bool = try await self.checkRoles(idToken: token)
            if (shouldRefreshToken) {
                _ = try await AuthService.getToken(forceRefresh: true)
            }
            return true
        } catch {
            print("ERROR: \(String(describing: error.localizedDescription))")
            return false
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
        
    }
    
    func isLoggedIn() async -> Bool {
        let isLoggedIn: Bool = Auth.auth().currentUser != nil
        if (isLoggedIn) {
            do {
                let shouldRefresh: Bool = try await self.checkRoles(idToken:Auth.auth().currentUser!.getIDToken())
                if (shouldRefresh) {
                    _ = try await AuthService.getToken(forceRefresh: true)
                }
                return isLoggedIn
            } catch {
                print(error)
                return false
            }
        }
        return isLoggedIn
    }
    
    static func getToken(forceRefresh: Bool = false) async throws -> String? {
        return try await Auth.auth().currentUser?.getIDTokenResult(forcingRefresh: forceRefresh).token
    }
    
    static func isAllowed(req: UserRole) -> Bool {
        let curr: UserRole = AuthService.role
        switch req {
        case .Guest:
            return curr == .Guest || curr == .Player || curr == .Admin
        case .Admin:
            return curr == .Admin
        case .Player:
            return curr == .Player || curr == .Admin
        case .Unauthorized:
            return curr == .Unauthorized
        }
    }
    
    static func updateRole() async {
        do {
            let result: AuthTokenResult? = try await Auth.auth().currentUser?.getIDTokenResult()
            guard let result = result else {
                AuthService.role = UserRole.Unauthorized
                return
            }
            
            print(result.token)
            
            guard let role = result.claims["role"] as? NSString else {
                print("No role found on token")
                AuthService.role =  UserRole.Unauthorized
                return
            }
            
            //AuthService.role =  .Admin
            
            
            switch role {
            case "isAdmin":
                AuthService.role =  UserRole.Admin
            case "isPlayer":
                AuthService.role =  UserRole.Player
            case "isGuest":
                AuthService.role =  UserRole.Guest
            default:
                AuthService.role =  UserRole.Unauthorized
            }
            
        } catch {
            print(error.localizedDescription)
            AuthService.role =  UserRole.Unauthorized
        }

    }
    
    func deleteUserData() {
        UserDefaults.standard.set(nil, forKey: "appleAuthorizedUserIdKey")
        Auth.auth().currentUser?.delete()
    }
}
