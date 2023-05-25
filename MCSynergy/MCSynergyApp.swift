//
//  MCSynergyApp.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 17/05/2023.
//

import SwiftUI
import Firebase

@main
struct MCSynergyApp: App {
    private let authService: AuthService
    @State var isLoggedIn: Bool
    
    
    init() {
        FirebaseApp.configure()
        
        self.authService = AuthService()
        
        self.isLoggedIn = authService.isLoggedIn()
    }
    
    
    
    var body: some Scene {
        WindowGroup {
            if (!isLoggedIn) {
                LoginView(authService: authService, isLoggedIn: $isLoggedIn)
                    .preferredColorScheme(.dark)
                    
                
            } else {
                TabView {
                    HomeView(authService: authService, isLoggedIn: $isLoggedIn)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .preferredColorScheme(.dark)
                    
                    NotificationsView()
                        .tabItem {
                            Label("Notifications", systemImage: "bell.fill")
                        }
                        .preferredColorScheme(.dark)

                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                        .preferredColorScheme(.dark)
                        
                }
            }
        }
    }
}
