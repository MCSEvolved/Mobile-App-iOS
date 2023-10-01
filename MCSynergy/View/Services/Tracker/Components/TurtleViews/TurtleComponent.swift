//
//  Created by Josian van Efferen on 02/07/2023.
//

import SwiftUI
import Foundation

struct TurtleComponent: View {
    @ObservedObject private var vm: TurtleComponentViewModel
    
    init(turtle: Turtle) {
        self.vm = TurtleComponentViewModel(turtle: turtle)
    }
    
    var body: some View {
        NavigationLink {
            TurtleDetailView(vm: vm)
        } label: {
            VStack {
                HStack {
                    Image(systemName: vm.isTurtle ? "tortoise.fill" : "desktopcomputer")
                        .font(.title2)
                        .padding(.trailing, 10)
                        .frame(width: 40)
                    VStack(alignment: .leading) {
                        HStack {
                            Text(vm.turtle.label ?? String(describing: vm.turtle.device))
                                .font(.title3)
                            Text("#\(vm.turtle.id)")
                                .font(.subheadline)
                                .foregroundStyle(Color.secondaryLabel)
                            Spacer()
                            Circle()
                                .fill(vm.timedOut ? .red : .green)
                                .frame(width: 15, height: 15)
                        }
                        Divider()
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Status")
                                    .font(.caption2)
                                    .foregroundStyle(Color.secondaryLabel)
                                Text(vm.turtle.status)
                                    .font(.title3)
                                    .foregroundStyle(vm.turtle.getStatusColor())
                            }
                            if vm.isTurtle {
                                VStack(alignment: .leading) {
                                    Text("Location")
                                        .font(.caption2)
                                        .foregroundStyle(Color.secondaryLabel)
                                    HStack {
                                        Text("\(String(vm.location.coordinates.x))/\(String(vm.location.coordinates.y))/\(String(vm.location.coordinates.z))")
                                            .font(.headline)
                                            .fontWeight(.regular)
                                            .redacted(reason: vm.isLoadingLocation ? .placeholder : .init())
                                        
                                    }
                                    
                                }
                                .padding(.leading, 5)
                            }
                            
                        }
                    }
                }
                if vm.isTurtle {
                    HStack {
                        ProgressView(value: $vm.fuelFracture.wrappedValue)
                            .tint($vm.fuelFracture.wrappedValue < 0.25 ? .orange : .green)
                            .background($vm.fuelFracture.wrappedValue == 0 ? .red : Color(UIColor.systemGray4))
                        
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 5, maxHeight: 5)
                    .background(Color(UIColor.systemGray4))
                }
                
            }
            .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
        }
        .listRowBackground(Color("SecondaryBackgroundColor"))
        
    }
}

#Preview {
    List {
        TurtleComponent(turtle: Turtle(id: 1, label: "Test Turtle", systemId: 1, device: .Advanced_Turtle, fuelLimit: 100000, status: "Returning", fuelLevel: 10000, lastUpdate: 1928, hasModem: true))
    }
}
