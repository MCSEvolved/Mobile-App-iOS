//
//  NotificationsView.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 25/05/2023.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
