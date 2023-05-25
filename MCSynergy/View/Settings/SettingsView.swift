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
    @State var handle: AuthStateDidChangeListenerHandle?
    
    var currentUser: User?
    
    init() {
        if (auth.currentUser != nil) {
            currentUser = auth.currentUser
        } else {
            //isLoggedIn = false
        }
    }
    
    
    var body: some View {
        NavigationStack {
            VStack() {
                List {
                    ProfileModule(currentUser: currentUser)
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
                                            .font(.title3)
                                    )
                                    .cornerRadius(10)
                            }
                                
                        }
                    }
                }
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color("PrimaryBackgroundColor"))
            .navigationTitle("Settings")
            .onAppear {
                handle = Auth.auth().addStateDidChangeListener { auth, user in
                    //isLoggedIn = authService.isLoggedIn()
                    
                }
            }
            .onDisappear {
                Auth.auth().removeStateDidChangeListener(handle!)
            }
        }
    }
}

struct ProfileModule: View {
    let currentUser: User?
    
    var body: some View {
        HStack {
            AsyncImage(url: currentUser?.photoURL) { image in image
                image
                    .resizable()
                    .cornerRadius(20)
                
            } placeholder: {
                ZStack {
                    Rectangle().fill(Color("SecondaryBackgroundColor"))
                    Label("Profile Pic Placeholrder", systemImage: "person.fill")
                        .labelStyle(.iconOnly).font(.largeTitle)
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 70, height: 70)
                .cornerRadius(20)
            }
            VStack(alignment: .leading) {
                Text(currentUser?.displayName ?? "John Doe")
                    .font(.title)
                Text("Player")
            }
            .padding(.leading, 10)
            
        }.alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
        
        Button(role: .destructive, action: {}) {
            HStack {
                Spacer()
                Text("Sign Out")
                Spacer()
            }
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
