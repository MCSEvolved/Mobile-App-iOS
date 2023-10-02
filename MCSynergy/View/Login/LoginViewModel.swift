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
        authService.signIn { _success, error in
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
    
    func signInWithApple() {
        Task.init {
            DispatchQueue.main.async {
                self.loading = true
            }
            _ = authService.signInWithApple()
            
            DispatchQueue.main.async {
                self.loading = false
            }
        }
    }
    
    func signInAsAnonymous() {
        Task.init {
            DispatchQueue.main.async {
                self.loading = true
            }
            _ = await authService.signInAsAnonymous()
            
            DispatchQueue.main.async {
                self.loading = false
            }
        }
    }
}
