//
//  HomeView.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 22/05/2023.
//

import SwiftUI
import Firebase

struct HomeView: View {
    
    private let authService: AuthService
    @State var handle: AuthStateDidChangeListenerHandle?
    @Binding var isLoggedIn: Bool
    
    init(authService: AuthService, isLoggedIn: Binding<Bool>) {
        self.authService = authService
        self._isLoggedIn = isLoggedIn
    }
    
    
    var body: some View {
        VStack() {
            Text(Auth.auth().currentUser?.displayName ?? "NoName")
            Button(action: authService.signOut) {
                Text("Sign Out")
            }
        }
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

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
