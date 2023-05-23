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
        self.provider = OAuthProvider(providerID: "microsoft.com")
        
    }
    
    func signIn(completion: @escaping (Bool) -> Void) {
        provider!.customParameters = [
            "prompt": "select_account"
        ]
        provider!.getCredentialWith(_:nil) { credential, error in
              if error != nil {
                  print("ERROR: \(String(describing: error?.localizedDescription))")
                  completion(false)
              }
              if credential != nil {
                  Auth.auth().signIn(with: credential!) { authResult, error in
                      if error != nil {
                          print("ERROR: \(String(describing: error?.localizedDescription))")
                          completion(false)
                      }
                      
                      // User is signed in.
                      // IdP data available in authResult.additionalUserInfo.profile.
                      // OAuth access token can also be retrieved:
                      // (authResult.credential as? OAuthCredential)?.accessToken
                      // OAuth ID token can also be retrieved:
                      // (authResult.credential as? OAuthCredential)?.idToken
                      //print("RESULT: \(authResult)")
                      completion(true)
                }
              }
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
}
