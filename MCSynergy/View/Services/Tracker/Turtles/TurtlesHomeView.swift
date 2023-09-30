//
//  TurtlesHomeView.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 03/07/2023.
//

import SwiftUI

struct TurtlesHomeView: View {
    @State private var selectedView = 0
    //var systems: [String] = ["No System", "Bee Farm", "Trading Hall", "Miner", "Charcoal Farm"]
    @ObservedObject private var vm: TurtlesHomeViewModel = TurtlesHomeViewModel()
    
    private func setUISegmentedControlAppearance() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.primaryBackgroundColor
        UISegmentedControl.appearance().backgroundColor = UIColor.secondaryBackgroundColor
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
    }
    
    
    init() {
        setUISegmentedControlAppearance()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Choose view", selection: $selectedView) {
                    Image(systemName: "tortoise.fill").tag(0)
                    Image(systemName: "envelope.fill").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                
                if ($selectedView.wrappedValue == 0) {
                    List {
                        Section(header: Text("Crashed")) {
                            ForEach(vm.crashedTurtles) { turtle in
                                TurtleComponent(turtle: turtle)
                            }
                        }
                        
                        Section(header: Text("Systems")) {
                            ForEach(vm.systems) { system in
                                NavigationLink(destination: SystemDetailView(system: system)) {
                                    Text(system.displayName)
                                }
                                .listRowBackground(Color.secondaryBackgroundColor)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .refreshable {
                        await vm.fetchCrashedTurtles()
                        await vm.fetchAllSystems()
                    }
                } else {
                    MessagesListView(sources: [.Turtle, .Computer])
                }
                Spacer()
                
            }
            .navigationTitle("Turtles").navigationBarTitleDisplayMode(.inline)
            .fillMaxSize()
            .background(Color.primaryBackgroundColor)
            
        }
        .fillMaxSize()
        .background(Color.primaryBackgroundColor)
        .task {
            await vm.fetchCrashedTurtles()
            await vm.fetchAllSystems()
        }
    }
}
