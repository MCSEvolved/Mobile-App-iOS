//
//  LoginView.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 22/05/2023.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    let authService: AuthService
    @State var handle: AuthStateDidChangeListenerHandle?
    @Binding var isLoggedIn: Bool
    @ObservedObject var vm: LoginViewModel
    
    init(authService: AuthService, isLoggedIn: Binding<Bool>) {
        self.authService = authService
        self.vm = LoginViewModel(_authService: authService)
        self._isLoggedIn = isLoggedIn
    }
    
    
    var body: some View {
        VStack() {
            Spacer()
            if (!vm.loading) {
                Button(action: vm.signInWithMicrosoft) {
                    Text("Sign In")
                }
                
            } else {
                ProgressView() {
                    Text("Logging in...")
                }
                
            }
            Spacer()
            
            
           
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color("PrimaryBackgroundColor"))
        
        .onAppear {
            handle = Auth.auth().addStateDidChangeListener { auth, user in
                isLoggedIn = authService.isLoggedIn()
                
            }
        }
        .onDisappear {
            Auth.auth().removeStateDidChangeListener(handle!)
        }
        
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
