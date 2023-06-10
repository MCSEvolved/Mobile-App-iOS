//
//  AuthService.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 22/05/2023.
//

import Foundation
import Firebase
import SwiftUI


class AuthService {
    var provider: OAuthProvider?
    
    init() {
        
    }
    
    func signIn(completion: @escaping (Bool) -> Void) {
        provider = OAuthProvider(providerID: "microsoft.com")
        guard let provider = provider else {
            print("ERROR: No provider found!")
            completion(false)
            return
        }
        provider.customParameters = [
            "prompt": "select_account"
        ]
        provider.getCredentialWith(_:nil) { credential, error in
              if error != nil {
                  print("ERROR: \(String(describing: error?.localizedDescription))")
                  completion(false)
              }
              if credential != nil {
                  Auth.auth().signIn(with: credential!) { authResult, error in
                      if (error != nil) {
                          print("ERROR: \(String(describing: error?.localizedDescription))")
                          completion(false)
                          return
                      }
                      
                      completion(true)
                }
              }
            }
    }
    
    func signInAsAnonymous(completion: @escaping (Bool) -> Void) {
        Auth.auth().signInAnonymously {authResult, error in
            if (error != nil) {
                print("ERROR: \(String(describing: error?.localizedDescription))")
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    func signOut() {
        
        do {
            try Auth.auth().signOut()
            
        }
        catch {
            print(error)
        }
        
    }
    
    func isLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func getToken() async throws -> String? {
        return try await Auth.auth().currentUser?.getIDToken()
    }
}
