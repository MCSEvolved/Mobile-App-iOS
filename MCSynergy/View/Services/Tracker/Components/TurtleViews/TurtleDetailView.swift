//
//  Created by Josian van Efferen on 30/09/2023.
//

import SwiftUI

struct TurtleDetailView: View {
    @State private var selectedView = 0
    private var vm: TurtleComponentViewModel
    
    private func setUISegmentedControlAppearance() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.primaryBackgroundColor
        UISegmentedControl.appearance().backgroundColor = UIColor.secondaryBackgroundColor
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
    }
    
    
    init(vm: TurtleComponentViewModel) {
        self.vm = vm
        setUISegmentedControlAppearance()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Choose view", selection: $selectedView) {
                    Image(systemName: "info.circle.fill").tag(0)
                    Image(systemName: "envelope.fill").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                
                if ($selectedView.wrappedValue == 0) {
                    TurtleInfoView(vm: vm)
                } else {
                    MessagesListView(sources: [.Turtle, .Computer], sourceIds: [String(vm.turtle.id)])
                        .onAppear {vm.removeObservers()}
                        .onDisappear {vm.addObservers()}
                }
                Spacer()
                
            } 
            .navigationTitle(vm.turtle.label ?? "\(vm.turtle.device.rawValue) #\(vm.turtle.id)").navigationBarTitleDisplayMode(.inline)
            .fillMaxSize()
            .background(Color.primaryBackgroundColor)
        }
        .fillMaxSize()
        .background(Color.primaryBackgroundColor)
    }
}

private struct TurtleInfoView: View {
    @ObservedObject private var vm: TurtleComponentViewModel
    
    @State private var enableLiveUpdate: Bool = SignalRClient.shared.isEnabled

    
    init(vm: TurtleComponentViewModel) {
        self.vm = vm
    }
    
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: vm.isTurtle ? "tortoise.fill" : "desktopcomputer")
                    .font(.title2)
                    .padding(.trailing, 10)
                    .frame(width: 40)
                
                Text(vm.turtle.label ?? String(describing: vm.turtle.device))
                    .font(.title3)
                Text("#\(vm.turtle.id)")
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryLabel)
                Spacer()
            }
            Divider()
                .padding(.vertical, 10)
            HStack {
                VStack(alignment: .leading) {
                    Text("Status")
                        .font(.caption2)
                        .foregroundStyle(Color.secondaryLabel)
                    Text(vm.turtle.status)
                        .font(.title3)
                        .foregroundStyle(vm.turtle.getStatusColor())
                }
                .frame(width: 140, alignment: .leading)
                
                VStack(alignment: .leading) {
                    Text("Last Update")
                        .font(.caption2)
                        .foregroundStyle(Color.secondaryLabel)
                    Text(vm.turtle.getTimeString())
                        .font(.title3)
                        .foregroundStyle(vm.timedOut ? .red : .green)
                    Text(vm.turtle.getDateString(format: "MMMM dd"))
                        .font(.subheadline)
                        .foregroundStyle(Color.secondaryLabel)
                }
                Spacer()
            }
            
            Divider()
                .padding(.vertical, 10)
            
            if vm.isTurtle {
                HStack(spacing: 15) {
                    VStack(alignment: .leading) {
                        Text("x")
                            .font(.caption2)
                            .foregroundStyle(Color.secondaryLabel)
                        Text(String(vm.location.coordinates.x))
                            .font(.title3)
                    }
                    VStack(alignment: .leading) {
                        Text("y")
                            .font(.caption2)
                            .foregroundStyle(Color.secondaryLabel)
                        Text(String(vm.location.coordinates.y))
                            .font(.title3)
                    }
                    VStack(alignment: .leading) {
                        Text("z")
                            .font(.caption2)
                            .foregroundStyle(Color.secondaryLabel)
                        Text(String(vm.location.coordinates.z))
                            .font(.title3)
                    }
                    VStack(alignment: .leading) {
                        Text("Dimension")
                            .font(.caption2)
                            .foregroundStyle(Color.secondaryLabel)
                        Text(String(vm.location.dimension))
                            .font(.title3)
                    }
                    Spacer()
                }
                .redacted(reason: vm.isLoadingLocation ? .placeholder : .init())
                Divider()
                    .padding(.vertical, 10)
                
                HStack {
                    ProgressView(value: $vm.fuelFracture.wrappedValue)
                        .tint($vm.fuelFracture.wrappedValue < 0.25 ? .orange : .green)
                        .background($vm.fuelFracture.wrappedValue == 0 ? .red : Color(UIColor.systemGray4))
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 5, maxHeight: 5)
                .background(Color(UIColor.systemGray4))
                HStack {
                    Text(String(vm.turtle.fuelLevel ?? 0))
                        .foregroundStyle(Color.secondaryLabel)
                        .font(.subheadline)
                    Spacer()
                }
            }

            Spacer()
        }
        .fillMaxSize()
        .padding(.vertical, 20)
        .padding(.horizontal, 30)
        .background(Color.secondaryBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: CGFloat(20)))
        .padding(10)
        .toolbar {
            Toggle(isOn: $enableLiveUpdate) {
                Image(systemName: enableLiveUpdate ? "wifi" : "wifi.slash")
            }
            .toggleStyle(.button)
            .onChange(of: enableLiveUpdate) { _, new in
                SignalRClient.shared.changeConnectionState(state: new)
            }
        }
    }
}

//#Preview {
//    @State var turtle = Turtle(id: 1, label: "Test Turtle", systemId: 1, device: .Advanced_Turtle, fuelLimit: 100000, status: "Returning", fuelLevel: 65135, lastUpdate: 192865362627, hasModem: true)
//    TurtleDetailView(turtle: $turtle)
//}
