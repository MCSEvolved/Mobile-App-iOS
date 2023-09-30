//
//  Created by Josian van Efferen on 17/05/2023.
//

import SwiftUI
import Firebase
import FirebaseMessaging
import UserNotifications
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        FirebaseApp.configure() // 1
        UNUserNotificationCenter.current().delegate = self // 3
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications() // 4
        return true
    }
}



extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([[.banner, .sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("ERROR: \(error)")
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: MessagingDelegate {

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        FCMTokenManager.shared.currentToken = fcmToken // 6
    }
}






@main
struct MCSynergyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    private var authService: AuthService
    private var notificationService: NotificationService
    @State var isLoggedIn: Bool = false
    @State var handle: AuthStateDidChangeListenerHandle?
    @State private var wsEnabled: Bool = true
    private var currentUser: User?
    
    
    
    init() {
        self.notificationService = Container.shared.resolveNotificationService()
        self.authService = Container.shared.resolveAuthService()
    }
    
    
    
    var body: some Scene {
        WindowGroup {
            if (!isLoggedIn) {
                LoginView(isLoggedIn: $isLoggedIn)
                    .preferredColorScheme(.dark)
                    .onAppear {
                        handle = Auth.auth().addStateDidChangeListener { _auth, _user in
                            isLoggedIn = authService.isLoggedIn()
                        }
                    }
                    .onDisappear {
                        Auth.auth().removeStateDidChangeListener(handle!)
                    }
                    
                
            } else {
                TabView {
                    NavigationStack {
                        HomeView()
                            .preferredColorScheme(.dark)
                    }
                    .tabItem {
                        Label("Services", systemImage: "antenna.radiowaves.left.and.right")
                    }
                   
                    NavigationStack {
                        NotificationsView()
                            .preferredColorScheme(.dark)
                    }
                    .tabItem {
                        Label("Notifications", systemImage: "bell.fill")
                    }
 
                    NavigationStack {
                        SettingsView()
                            .preferredColorScheme(.dark)
                    }
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                }
                .task {
                    if (isLoggedIn) {
                        await AuthService.updateRole()
                        print(AuthService.role)
                        if (AuthService.role == .Unauthorized) {
                            authService.signOut()
                            isLoggedIn = false
                            return
                        }
                        
                        await SignalRClient.shared.configureHubConnection()
                    }
                    
                }.onAppear {
                    
                    handle = Auth.auth().addStateDidChangeListener { _auth, _user in
                        isLoggedIn = authService.isLoggedIn()
                        
                    }
                    
                    guard let user = Auth.auth().currentUser else {
                        isLoggedIn = false
                        return
                    }
                    
                    if (!user.isAnonymous) {
                        notificationService.requestPermission { _granted, error in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    }
                    
                }.onDisappear {
                    Auth.auth().removeStateDidChangeListener(handle!)
                }
            }
        }
    }
}
