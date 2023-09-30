//
//  Created by Josian van Efferen on 02/07/2023.
//

import SwiftUI

struct TrackerHomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    TrackerSection(title: "Turtles", icon: "tortoise.fill", font: .caption2) { TurtlesHomeView() }
                    TrackerSection(title: "Systems", icon: "point.3.filled.connected.trianglepath.dotted") { Text("Systems") }
                    if (AuthService.isAllowed(req: .Player)) {
                        TrackerSection(title: "Services", icon: "antenna.radiowaves.left.and.right") { Text("Services") }
                    }
                    

                }
                .background(Color.primaryBackgroundColor)
                .scrollContentBackground(.hidden)
            }
            .background(Color.primaryBackgroundColor)
            .navigationTitle("Tracker")
        }
        .fillMaxWidth()
        .background(Color.primaryBackgroundColor)
    }
}

private struct TrackerSection<Content: View>: View {
    var title: String
    var icon: String
    var font: Font = .subheadline
    @ViewBuilder var nextPage: Content
    
    var body: some View {
        NavigationLink {
            nextPage
        } label: {
            Label {
                Text(title)
            } icon: {
                Rectangle()
                    .fill(Color.accentColor)
                    .frame(width: 30, height: 30, alignment: .center)
                    .overlay(
                        Image(systemName: icon)
                            .foregroundColor(.white)
                            .font(font)
                    )
                    .cornerRadius(10)
            }
                
        }.listRowBackground(Color.secondaryBackgroundColor)
    }
        
}
