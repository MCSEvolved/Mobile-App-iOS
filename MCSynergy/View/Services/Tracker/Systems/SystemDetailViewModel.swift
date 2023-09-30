//
//  Created by Josian van Efferen on 23/09/2023.
//

import Foundation

class SystemDetailViewModel: ObservableObject {
    @Published var normalTurtles: [Turtle] = []
    @Published var crashedTurtles: [Turtle] = []
    @Published var warningTurtles: [Turtle] = []
    @Published var isLoading: Bool = true
    @Published var hasTurtles: Bool = false
    private let trackerService: TrackerService = Container.shared.resolveTrackerService()
    private let system: System
    
    init(system: System) {
        self.system = system
    }
    
    public func fetchTurtles() async {
        do {
            let turtles: [Turtle] = try await trackerService.getTurtlesBySystem(systemId: system.id)
            var _crashed: [Turtle] = []
            var _warning: [Turtle] = []
            var _normal: [Turtle] = []
            turtles.forEach { turtle in
                switch turtle.getStatusColor() {
                case .red:
                    _crashed.append(turtle)
                case .orange:
                    _warning.append(turtle)
                default:
                    _normal.append(turtle)
                }
            }
            DispatchQueue.main.async { [weak self, _normal, _warning, _crashed] in
                self?.normalTurtles = _normal
                self?.crashedTurtles = _crashed
                self?.warningTurtles = _warning
                self?.isLoading = false
                self?.hasTurtles = !_normal.isEmpty || !_warning.isEmpty || !_crashed.isEmpty
            }
        } catch {
            print(error)
        }
        
    }
}
