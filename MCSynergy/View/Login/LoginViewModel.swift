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
    
    init(_authService: AuthService) {
        self.authService = _authService
    }
    
    func signInWithMicrosoft() {
        DispatchQueue.main.async {
            self.loading = true
        }
        authService.signIn() { success in
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
