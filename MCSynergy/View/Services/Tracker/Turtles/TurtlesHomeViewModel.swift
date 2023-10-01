//
//  Created by Josian van Efferen on 19/09/2023.
//

import Foundation

class TurtlesHomeViewModel: ObservableObject {
    @Published var crashedTurtles: [Turtle] = []
    @Published var systems: [System] = []
    private let trackerService: TrackerService = Container.shared.resolveTrackerService()
    
    public func fetchCrashedTurtles() async {
        do {
            let crashedTurtles: [Turtle] = try await trackerService.getAllCrashedTurtles()
            DispatchQueue.main.async { [weak self] in
                self?.crashedTurtles = crashedTurtles
            }
        } catch {
            print(error)
        }
        
    }
    
    public func fetchAllSystems() async {
        do {
            let systems: [System] = try await trackerService.getAllSystems()
            DispatchQueue.main.async { [weak self] in
                self?.systems = systems
                self?.systems.insert(System(id: 0, displayName: "No System", description: "Turtles who are not part of a specific system", produces: []), at: 0)
            }
        } catch {
            print(error)
        }
    }
    
}
