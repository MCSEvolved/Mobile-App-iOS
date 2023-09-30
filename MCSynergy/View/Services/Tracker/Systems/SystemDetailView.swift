//
//  Created by Josian van Efferen on 23/09/2023.
//

import SwiftUI

struct SystemDetailView: View {
    @State private var selectedView = 0
    @ObservedObject private var vm: SystemDetailViewModel
    private let system: System
    
    private func setUISegmentedControlAppearance() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.primaryBackgroundColor
        UISegmentedControl.appearance().backgroundColor = UIColor.secondaryBackgroundColor
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
    }
    
    init(system: System) {
        vm = SystemDetailViewModel(system: system)
        self.system = system
        setUISegmentedControlAppearance()
    }
    
    var body: some View {
        NavigationStack {
            if !vm.isLoading && vm.hasTurtles {
                VStack {
                    Picker("Choose view", selection: $selectedView) {
                        Image(systemName: "tortoise.fill").tag(0)
                        Image(systemName: "envelope.fill").tag(1)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if ($selectedView.wrappedValue == 0) {
                        List {
                            if (!$vm.crashedTurtles.isEmpty || !$vm.warningTurtles.isEmpty) {
                                Section(header: Text("Need Attention")) {
                                    ForEach($vm.crashedTurtles) { turtle in
                                        TurtleComponent(turtle: turtle.wrappedValue)
                                    }
                                    ForEach($vm.warningTurtles) { turtle in
                                        TurtleComponent(turtle: turtle.wrappedValue)
                                    }
                                }
                            }
                            if (!$vm.normalTurtles.isEmpty) {
                                Section(header: Text("Operational")) {
                                   ForEach($vm.normalTurtles) { turtle in
                                       TurtleComponent(turtle: turtle.wrappedValue)
                                   }
                               }
                            }
                        }
                        .refreshable {
                            await vm.fetchTurtles()
                        }
                        .scrollContentBackground(.hidden)
                        
                    } else {
                        MessagesListView(sources: [.Turtle, .Computer, .System], system: system)
                    }
                    Spacer()
                    
                }
                .navigationTitle(system.displayName).navigationBarTitleDisplayMode(.inline)
                .fillMaxSize()
                .background(Color.primaryBackgroundColor)
            } else if !vm.isLoading && !vm.hasTurtles {
                VStack(alignment: .center) {
                    Spacer()
                    Text("\(system.displayName) has no turtles or computers")
                        .font(.body)
                        .foregroundStyle(Color.secondaryLabel)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .fillMaxSize(alignment: .center)
                .padding(20)
            } else {
                VStack(alignment: .center) {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .fillMaxSize(alignment: .center)
            }

        }
        .fillMaxSize()
        .background(Color.primaryBackgroundColor)
        .task {
            await vm.fetchTurtles()
        }

    }
}

//#Preview {
//    SystemDetailView()
//}
