//
//  TurtlesRepository.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 03/07/2023.
//

import Foundation

class TrackerRepository {
    
    private let turtleDAO: TurtleDAO = TurtleDAO()
    private let locationDAO: LocationDAO = LocationDAO()
    private let messageDAO: MessageDAO = MessageDAO()
    
    func GetAllComputers() async throws -> [Turtle] {
        let data: Data = try await turtleDAO.GetAllComputers()
        var turtles: [Turtle] = try JSONDecoder().decode([Turtle].self, from: data)
        return turtles
    }
    
    func GetComputerById(id: Int) async throws -> Turtle {
        let data: Data = try await turtleDAO.GetComputerById(id: id)
        var turtle: Turtle = try JSONDecoder().decode(Turtle.self, from: data)
        return turtle
    }
    
    func GetComputersByService(serviceId: Int) async throws -> [Turtle] {
        return []
    }
    
    func GetAllMessages(page: Int, pageSize: Int) async throws {
        
    }
    
    func GetAllMessagesBySource(page: Int, pageSize: Int) async throws {
        
    }
    
    func GetAllMessagesBySourceIds(page: Int, pageSize: Int, sourceIds: [String]) async throws {
        
    }
    
    func GetAllMessagesByType(page: Int, pageSize: Int, type: String) async throws {
        
    }
    
    func GetLocationOfTurtle(computerId: Int) async throws {
        
    }
    
}
