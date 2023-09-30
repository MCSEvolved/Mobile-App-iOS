//
//  Created by Josian van Efferen on 25/05/2023.
//

import SwiftUI

struct NotificationSettings: View {
    private let notificationService: NotificationService
    @State var notificationsEnabled: Bool
    
    init() {
        self.notificationService = Container.shared.resolveNotificationService()
        self._notificationsEnabled = State(initialValue: notificationService.isEnabled())
    }
    
//    "/topics/mc-server",
//        "/topics/user_weekly-report",
//        "/topics/power-management_shortage",
//        "/topics/power-management_reactor-shut-off",
//        "/topics/service-status_tracker",
//        "/topics/service-status_storage",
//        "/topics/service-status_emerald-exchange",
//        "/topics/service-status_reactor-manager",
//        "/topics/tracker_error",
//        "/topics/tracker_warning",
//        "/topics/tracker_out-of-fuel"
    
    var body: some View {
        NavigationStack {
            VStack {
                
                List {
                    if (!notificationsEnabled) {
                        Text("You didn't give permission for push notifications, go to your phone settings to enable it.")
                            .listRowBackground(Color.secondaryBackgroundColor)
                    }
                    
                    Section(header:Text("Minecraft Server Status")) {
                        NotificationSettingItem(notificationName: "Shut on/off", topic: "mc-server")
                    }
                    
                    Section(header:Text("Service Status")) {
                        NotificationSettingItem(notificationName: "Tracker", topic: "service-status_tracker")
                        NotificationSettingItem(notificationName: "Storage", topic: "service-status_storage")
                        NotificationSettingItem(notificationName: "EmeraldExchange", topic: "service-status_emerald-exchange")
                        NotificationSettingItem(notificationName: "ReactorManager", topic: "service-status_reactor-manager")
                    }
                    
                    Section(header:Text("Power Management")) {
                        NotificationSettingItem(notificationName: "Power Shortage", topic: "power-management_shortage")
                        NotificationSettingItem(notificationName: "Reactor Shut off", topic: "power-management_reactor-shut-off")
                    }
                    
                    Section(header:Text("Tracker")) {
                        NotificationSettingItem(notificationName: "Error Messages", topic: "tracker_error")
                        NotificationSettingItem(notificationName: "Warning Messages", topic: "tracker_warning")
                        NotificationSettingItem(notificationName: "Out of Fuel", topic: "tracker_out-of-fuel")
                    }
                    
                    Section(header:Text("Personal")) {
                        //NotificationSettingItem(notificationName: "Personal Messages")
                        NotificationSettingItem(notificationName: "Weekly Reports", topic: "user_weekly-report")
                    }
                    
                }
                .background(Color.primaryBackgroundColor)
                .scrollContentBackground(.hidden)
                .disabled(!notificationsEnabled)
            }.background(Color.primaryBackgroundColor)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .navigationTitle("Notifications").navigationBarTitleDisplayMode(.inline)
        //.toolbarBackground(.visible, for: .navigationBar)
        .background(Color.primaryBackgroundColor)
        .onAppear {
            self.notificationsEnabled = notificationService.isEnabled()
        }
        
    }
}

struct NotificationSettingItem: View {
    private let notificationService: NotificationService
    let notificationName: String
    let topic: String
    @State var isEnabled: Bool
    
    init(notificationName: String, topic: String) {
        self.notificationService = Container.shared.resolveNotificationService()
        self.notificationName = notificationName
        self.topic = topic
        self.isEnabled = notificationService.getStateOfTopic(topic: topic)
    }
    
    var body: some View {
        HStack {
            Toggle(notificationName, isOn: $isEnabled)
                .onChange(of: isEnabled) { old, new in
                    notificationService.changeStateOfTopic(topic: topic, state: new)
                }
        }
        .listRowBackground(Color.secondaryBackgroundColor)
        .onAppear {
            self.isEnabled = notificationService.getStateOfTopic(topic: topic)
        }
    }
}

//struct NotificationSettings_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            NotificationSettings()
//        }
//        
//    }
//}
