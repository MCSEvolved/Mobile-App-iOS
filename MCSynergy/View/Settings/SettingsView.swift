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
    @State var liveOnData: Bool = true
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
        VStack {
            List {
                ProfileModule(currentUser: currentUser)
                    .listRowBackground(Color.secondaryBackgroundColor)
                Section {
                    
                    
                    NavigationLink {
                        NotificationSettings()
                    } label: {
                        HStack {
                            Rectangle()
                                .fill(.red)
                                .frame(width: 35, height: 35, alignment: .center)
                                .overlay(
                                    Image(systemName: "bell.badge.fill")
                                        .foregroundColor(.white)
                                        .font(.title3)
                                )
                                .cornerRadius(10)
                            Spacer().frame(width: 15)
                            Text("Notifications")
                        }
                    }.listRowBackground(Color.secondaryBackgroundColor)
                    
                    Toggle(isOn: $liveOnData) {
                        HStack {
                            Rectangle()
                                .fill(.blue)
                                .frame(width: 35, height: 35, alignment: .center)
                                .overlay(
                                    Image(systemName: "wifi")
                                        .foregroundColor(.white)
                                        .font(.title3)
                                )
                                .cornerRadius(10)
                            Spacer().frame(width: 15)
                            VStack(alignment: .leading) {
                                Text("Use Mobile Data")
                                Text("Use mobile data to get live updates from services, this can significantly increases data usage.")
                                    .font(.caption)
                                    .foregroundStyle(Color.secondaryLabel)
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                    .listRowBackground(Color.secondaryBackgroundColor)
                    .disabled(true)
                    
//                    Toggle(isOn: $enabled) {
//                        Label {
//                            Text("Monthly Newsletter")
//                        } icon: {
//                            Rectangle()
//                                .fill(.blue)
//                                .frame(width: 30, height: 30, alignment: .center)
//                                .overlay(
//                                    Image(systemName: "envelope.fill")
//                                        .foregroundColor(.white)
//                                        .font(.subheadline)
//                                )
//                                .cornerRadius(10)
//                        }
//                    }
//                    .listRowBackground(Color.secondaryBackgroundColor)
//                    .disabled(true)
                }
            }
            .background(Color.primaryBackgroundColor)
            .scrollContentBackground(.hidden)
        }
        .background(Color.primaryBackgroundColor)
        .navigationTitle("Settings")
        .fillMaxWidth()
        .background(Color.primaryBackgroundColor)
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
                    Rectangle().fill(Color.primaryBackgroundColor)
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
            
        }.alignmentGuide(.listRowSeparatorLeading) { _ in return 0 }
        
        Button(role: .destructive, action: authService.signOut ) {
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
        NavigationStack {
            SettingsView()
        }
        
    }
}
