//
//  Created by Josian van Efferen on 01/10/2023.
//

import Foundation

class TurtleComponentViewModel: ObservableObject {
    @Published var turtle: Turtle
    @Published var location: Location
    @Published var isTurtle: Bool
    @Published var timedOut: Bool = true
    @Published var fuelFracture: Float = 1.0
    
    @Published var isLoadingLocation: Bool = true
    
    private var timedOutTimer: Timer?
    
    init(turtle: Turtle) {
        self.turtle = turtle
        self.location = Location(computerId: turtle.id, coordinates: Coordinates(x: 9999, y: 9999, z: 9999), dimension: "Unknown", createdOn: 0)
        self.isTurtle = turtle.device == .Turtle || turtle.device == .Advanced_Turtle
        addObservers()
        if isTurtle {
            updateFuelFracture()
            fetchLocation()
        }
    }
    
    deinit {
        removeObservers()
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(newComputerReceived), name: .newComputer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newLocationReceived), name: .newLocation, object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .newComputer, object: nil)
        NotificationCenter.default.removeObserver(self, name: .newLocation, object: nil)
    }
    
    private func updateFuelFracture() {
        let level: Float = Float(turtle.fuelLevel ?? 1)
        let limit: Float = Float(turtle.fuelLimit ?? 1)
        DispatchQueue.main.async { [weak self] in
            self?.fuelFracture = level/limit
        }
    }
    
    private func fetchLocation() {
        Task.init {
            do {
                let location = try await TrackerService.shared.getLocationOfTurtle(computerId: turtle.id)
                DispatchQueue.main.async { [weak self] in
                    self?.location = location
                    self?.isLoadingLocation = false
                }
            } catch {
                print(error)
            }
        }
    }
    
    @objc private func newComputerReceived(notification: Notification) {
        let receivedTurtle: Turtle? = notification.userInfo?["computer"] as? Turtle
        guard let receivedTurtle = receivedTurtle else {
            return
        }
        if receivedTurtle.id == turtle.id {
            DispatchQueue.main.async { [weak self] in
                self?.turtle = receivedTurtle
                self?.timedOut = false
            }
            updateFuelFracture()
            timedOutTimer?.invalidate()
            timedOutTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
                DispatchQueue.main.async { [weak self] in
                    self?.timedOut = true
                }
            }
        }
    }
    
    @objc private func newLocationReceived(notification: Notification) {
        let receivedLocation: Location? = notification.userInfo?["location"] as? Location
        guard let receivedLocation = receivedLocation else {
            return
        }
        if receivedLocation.computerId == turtle.id {
            DispatchQueue.main.async { [weak self] in
                self?.location = receivedLocation
            }
        }
    }
}
