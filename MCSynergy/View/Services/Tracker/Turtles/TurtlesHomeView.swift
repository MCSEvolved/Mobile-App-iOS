//
//  TurtlesHomeView.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 03/07/2023.
//

import SwiftUI

struct TurtlesHomeView: View {
    @State private var selectedView = 0
    @State var turtle = Turtle(id: 1, label: "Test Harvesting Turtle", systemId: 1, device: .Advanced_Turtle, fuelLimit: 100000, status: "Error", fuelLevel: 24000, lastUpdate: 4001932, hasModem: true)
    var systems: [String] = ["No System", "Bee Farm", "Trading Hall", "Miner", "Charcoal Farm"]
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "PrimaryBackgroundColor")
        UISegmentedControl.appearance().backgroundColor = UIColor(named: "SecondaryBackgroundColor")
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
    }
    
    var body: some View {
        NavigationStack {
            VStack() {
                Picker("Choose view", selection: $selectedView) {
                    Image(systemName: "tortoise.fill").tag(0)
                    Image(systemName: "envelope.fill").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                
                if ($selectedView.wrappedValue == 0) {
                    List {
                        Section(header: Text("Crashed")) {
                            TurtleComponent(turtle: $turtle)
                            TurtleComponent(turtle: $turtle)
                        }
                        Section(header: Text("Systems")) {
                            ForEach(systems, id: \.self) { system in
                                NavigationLink(destination: Text(system)) {
                                    Text(system)
                                }
                                .listRowBackground(Color("SecondaryBackgroundColor"))
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                } else {
                    MessagesComponent()
                }
                Spacer()
                
            }
            .navigationTitle("Turtles").navigationBarTitleDisplayMode(.inline)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color("PrimaryBackgroundColor"))
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        
        .background(Color("PrimaryBackgroundColor"))
    }
}

//#Preview {
//    TurtlesHomeView()
//}

//Turtle(id: 1, label: "Test Harvesting Turtle", systemId: 1, device: .Advanced_Turtle, fuelLimit: 100000, status: "Harvesting", fuelLevel: 60941, lastUpdate: 4001932, hasModem: true)
