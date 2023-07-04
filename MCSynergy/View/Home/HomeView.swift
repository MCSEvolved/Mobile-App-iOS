//
//  HomeView.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 22/05/2023.
//

import SwiftUI
import Firebase

struct HomeView: View {
    var role: UserRole = AuthService.role
    

    
    
    var body: some View {
        NavigationStack {
            VStack() {
                List {
                    ServiceCard(title: "Tracker", description: "Easy way to keep track of all your turtles and systems") { TrackerHomeView() }
//                    ServiceCard(title: "EmeraldExchange", description: "Trade every item the villagers have to offer right from the app") { TrackerHomeView() }
//                    ServiceCard(title: "Nuclear Reactor Manager", description: "See what our (very safe, totally not going to meltdown) reactor is doing") { TrackerHomeView() }
//                    if (AuthService.isAllowed(req: .Player)) {
//                        ServiceCard(title: "Docs", description: "See all the documentation of all the services") { TrackerHomeView() }
//                    }
//                    if (AuthService.isAllowed(req: .Admin)) {
//                        ServiceCard(title: "Admin Panel", description: "Manage all the Docker containers and the NGINX config") { TrackerHomeView() }
//                    }
                    
                }
                .background(Color("PrimaryBackgroundColor"))
                .scrollContentBackground(.hidden)
            }
            .background(Color("PrimaryBackgroundColor"))
            .navigationTitle("Services")
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color("PrimaryBackgroundColor"))
    }
}

private struct ServiceCard<Content: View>: View {
    var title: String
    var description: String
    @ViewBuilder var serviceView: Content
    
    var body: some View {
        NavigationLink(destination: serviceView) {
            HStack() {
                Image(systemName: "antenna.radiowaves.left.and.right")
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(description)
                        .foregroundStyle(Color(UIColor.secondaryLabel))
                        .font(.body)
                }
            }
            
        }.listRowBackground(Color("SecondaryBackgroundColor"))
        
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
