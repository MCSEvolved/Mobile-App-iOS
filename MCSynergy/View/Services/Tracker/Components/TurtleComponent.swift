//
//  Created by Josian van Efferen on 02/07/2023.
//

import SwiftUI
import Foundation

struct TurtleComponent: View {
    @State var turtle: Turtle
    @State var location: Location
    private let hasLocation: Bool
    @State var timedOut: Bool = true
    @State var fuelFracture: Float = 1.0
    
    private let newComputerPub: NotificationCenter.Publisher
    private let newLocationPub: NotificationCenter.Publisher
    @State private var timedOutTimer: Timer?
    
    init(turtle: Turtle) {
        self._turtle = State(initialValue: turtle)
        self._location = State(initialValue: Location(computerId: turtle.id, coordinates: Coordinates(x: 9999, y: 9999, z: 9999), dimension: "Unknown", createdOn: 0))
        self.hasLocation = turtle.device == .Turtle || turtle.device == .Advanced_Turtle
        newComputerPub = NotificationCenter.default.publisher(for: .newComputer)
        newLocationPub = NotificationCenter.default.publisher(for: .newLocation)
    }
    
    private func updateFuel() {
        let level: Float = Float(turtle.fuelLevel ?? 1)
        let limit: Float = Float(turtle.fuelLimit ?? 1)
                              
        fuelFracture = level/limit
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: hasLocation ? "tortoise.fill" : "desktopcomputer")
                    .font(.title2)
                    .padding(.trailing, 10)
                    .frame(width: 40)
                VStack(alignment: .leading) {
                    HStack {
                        Text(turtle.label ?? String(describing: turtle.device))
                            .font(.title3)
                        Text("#\(turtle.id)")
                            .font(.subheadline)
                            .foregroundStyle(Color(UIColor.secondaryLabel))
                        Spacer()
                        Circle()
                            .fill(timedOut ? .red : .green)
                            .frame(width: 15, height: 15)
                    }
                    Divider()
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Status")
                                .font(.caption2)
                                .foregroundStyle(Color(UIColor.secondaryLabel))
                            Text(turtle.status)
                                .font(.title3)
                                .foregroundStyle(turtle.getStatusColor())
                        }
                        if hasLocation {
                            VStack(alignment: .leading) {
                                Text("Location")
                                    .font(.caption2)
                                    .foregroundStyle(Color(UIColor.secondaryLabel))
                                HStack {
                                    Text("\(String(location.coordinates.x))/\(String(location.coordinates.y))/\(String(location.coordinates.z))")
                                        .font(.headline)
                                        .fontWeight(.regular)
        
                                }
                                
                            }
                            .padding(.leading, 5)
                        }
    
                    }
                }
            }
            HStack {
                ProgressView(value: $fuelFracture.wrappedValue)
                    .tint($fuelFracture.wrappedValue < 0.25 ? .orange : .green)
                    .background($fuelFracture.wrappedValue == 0 ? .red : Color(UIColor.systemGray4))
                
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 5, maxHeight: 5)
            .background(Color(UIColor.systemGray4))
        }
        .listRowBackground(Color("SecondaryBackgroundColor"))
        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in return 0 }
        .onAppear {
            updateFuel()
        }
        .task {
            if hasLocation {
                do {
                    let location = try await TrackerService.shared.getLocationOfTurtle(computerId: turtle.id)
                    self.location = location
                } catch {
                    print(error)
                }
            }
        }
        .onReceive(newComputerPub) { computer in
            let receivedTurtle: Turtle? = computer.userInfo?["computer"] as? Turtle
            guard let receivedTurtle = receivedTurtle else {
                return
            }
            if receivedTurtle.id == turtle.id {
                turtle = receivedTurtle
                updateFuel()
                timedOut = false
                timedOutTimer?.invalidate()
                timedOutTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
                    timedOut = true
                }
            }
        }
        .onReceive(newLocationPub) { location in
            let receivedLocation: Location? = location.userInfo?["location"] as? Location
            guard let receivedLocation = receivedLocation else {
                return
            }
            if receivedLocation.computerId == turtle.id {
                self.location = receivedLocation
            }
        }
        
    }
}

#Preview {
    List {
        TurtleComponent(turtle: Turtle(id: 1, label: "Test Turtle", systemId: 1, device: .Advanced_Turtle, fuelLimit: 100000, status: "Returning", fuelLevel: 10000, lastUpdate: 1928, hasModem: true))
    }
}
