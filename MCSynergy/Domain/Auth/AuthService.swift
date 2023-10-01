//
//  Created by Josian van Efferen on 22/05/2023.
//

import Foundation
import Firebase
import SwiftUI

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


class AuthService {
    private var provider: OAuthProvider?
    private let baseUrl: String = "https://api.mcsynergy.nl"
    
    static var role: UserRole = .Unauthorized
    
    init() {
        
    }
    
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
}
