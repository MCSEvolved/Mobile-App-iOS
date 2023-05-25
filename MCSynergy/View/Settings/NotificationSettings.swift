//
//  NotificationSettings.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 25/05/2023.
//

import SwiftUI

struct NotificationSettings: View {
    var body: some View {
        NavigationStack {
            VStack() {
                List {
                    Section(header:Text("Minecraft Server Status")) {
                        NotificationSettingItem(notificationName: "Shut on/off", isEnabled: false)
                    }
                    
                    Section(header:Text("Power Management")) {
                        NotificationSettingItem(notificationName: "Power Shortage", isEnabled: false)
                        NotificationSettingItem(notificationName: "Reactor Shut off", isEnabled: false)
                    }
                    
                    Section(header:Text("Tracker")) {
                        NotificationSettingItem(notificationName: "Error Messages", isEnabled: true)
                        NotificationSettingItem(notificationName: "Warning Messages", isEnabled: true)
                        NotificationSettingItem(notificationName: "Out of Fuel", isEnabled: true)
                    }
                    
                    Section(header:Text("Personal")) {
                        NotificationSettingItem(notificationName: "Personal Messages", isEnabled: true)
                        NotificationSettingItem(notificationName: "Weekly Reports", isEnabled: false)
                    }
                    
                }
            }
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color("PrimaryBackgroundColor"))
        .navigationTitle("Notifications")
    }
}

struct NotificationSettingItem: View {
    let notificationName: String
    @State var isEnabled: Bool
    var body: some View {
        HStack {
            //Text(notificationName)
            Toggle(notificationName, isOn: $isEnabled)
        }
    }
}

struct NotificationSettings_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NotificationSettings()
        }
        
    }
}
