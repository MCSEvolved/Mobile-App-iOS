//
//  LoginViewModel.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 22/05/2023.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var loading: Bool = false
    private let authService: AuthService
    
    init() {
        self.authService = Container.shared.resolveAuthService()
    }
    
    func signInWithMicrosoft() {
        DispatchQueue.main.async {
            self.loading = true
        }
        authService.signIn() { success, error in
            guard error == nil else {
                print(String(describing: error?.localizedDescription))
                DispatchQueue.main.async {
                    self.loading = false
                }
                return
            }
            DispatchQueue.main.async {
                self.loading = false
            }
        }
    }
    
    func signInAsAnonymous() {
        DispatchQueue.main.async {
            self.loading = true
        }
        authService.signInAsAnonymous() { success in
            DispatchQueue.main.async {
                self.loading = false
            }
        }
    }
}
