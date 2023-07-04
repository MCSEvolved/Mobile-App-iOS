//
//  SettingsView.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 22/05/2023.
//

import SwiftUI
import Firebase

struct SettingsView: View {
    private let auth = Auth.auth()
    private let authService: AuthService
    private let notificationService: NotificationService
    @State var handle: AuthStateDidChangeListenerHandle?
    @State var enabled: Bool = false
    var currentUser: User?
    
    init() {
        self.notificationService = Container.shared.resolveNotificationService()
        self.authService = Container.shared.resolveAuthService()
        if (auth.currentUser != nil) {
            currentUser = auth.currentUser
        } else {
            authService.signOut()
        }
        
        
    }
    
    
    var body: some View {
        NavigationStack {
            VStack() {
                List {
                    ProfileModule(currentUser: currentUser)
                        .listRowBackground(Color("SecondaryBackgroundColor"))
                    Section() {
                        
                        
                        NavigationLink{
                            NotificationSettings()
                        } label: {
                            Label {
                                Text("Notifications")
                            } icon: {
                                Rectangle()
                                    .fill(.red)
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .overlay(
                                        Image(systemName: "bell.badge.fill")
                                            .foregroundColor(.white)
                                            .font(.subheadline)
                                    )
                                    .cornerRadius(10)
                            }
                                
                        }.listRowBackground(Color("SecondaryBackgroundColor"))
                        
                        
                        
                        Toggle(isOn: $enabled) {
                            Label {
                                Text("Monthly Newsletter")
                            } icon: {
                                Rectangle()
                                    .fill(.blue)
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .overlay(
                                        Image(systemName: "envelope.fill")
                                            .foregroundColor(.white)
                                            .font(.subheadline)
                                    )
                                    .cornerRadius(10)
                            }
                        }
                        .listRowBackground(Color("SecondaryBackgroundColor"))
                        .disabled(true)
                    }
                }
                .background(Color("PrimaryBackgroundColor"))
                .scrollContentBackground(.hidden)
            }
            .background(Color("PrimaryBackgroundColor"))
            .navigationTitle("Settings")
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color("PrimaryBackgroundColor"))
    }
}

struct ProfileModule: View {
    let currentUser: User?
    let authService: AuthService = Container.shared.resolveAuthService()
    var body: some View {
        HStack {
            AsyncImage(url: currentUser?.photoURL) { image in image
                image
                    .resizable()
                    .cornerRadius(20)
                
            } placeholder: {
                ZStack {
                    Rectangle().fill(Color("PrimaryBackgroundColor"))
                    Label("Profile Pic Placeholder", systemImage: "person.fill")
                        .labelStyle(.iconOnly).font(.largeTitle)
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 70, height: 70)
                .cornerRadius(20)
            }
            VStack(alignment: .leading) {
                Text(currentUser?.displayName ?? "Guest")
                    .font(.title)
                Text(String(describing: AuthService.role))
            }
            .padding(.leading, 10)
            
        }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
        
        Button(role: .destructive, action: authService.signOut ) {
            HStack {
                Spacer()
                Text("Sign Out")
                Spacer()
            }
            
        }
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            SettingsView(_authService: AuthService(), _notificationService: NotificationService())
//        }
//        
//    }
//}
