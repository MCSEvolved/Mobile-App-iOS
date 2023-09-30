//
//  TurtlesRepository.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 03/07/2023.
//

import Foundation

class TrackerRepository {
    
    private lazy var turtleDAO: TurtleDAO = TurtleDAO()
    private lazy var locationDAO: LocationDAO = LocationDAO()
    private lazy var messageDAO: MessageDAO = MessageDAO()
    private lazy var systemDAO: SystemDAO = SystemDAO()
    
    func getAllComputers() async throws -> [Turtle] {
        let data: Data = try await turtleDAO.getAllComputers()
        let turtles: [Turtle] = try JSONDecoder().decode([Turtle].self, from: data)
        return turtles
    }
    
    func getAllCrashedTurtles() async throws -> [Turtle] {
        let turtles: [Turtle] = try await getAllComputers()
        var crashedTurtles: [Turtle] = []
        turtles.forEach { turtle in
            if (turtle.status == "Error") {
                crashedTurtles.append(turtle)
            }
        }
        
        return crashedTurtles
    }
    
    func getComputerById(id: Int) async throws -> Turtle {
        let data: Data = try await turtleDAO.getComputerById(id: id)
        let turtle: Turtle = try JSONDecoder().decode(Turtle.self, from: data)
        return turtle
    }
    
    func getComputersBySystem(systemId: Int) async throws -> [Turtle] {
        let data: Data = try await turtleDAO.getComputersBySystem(systemId: systemId)
        let turtles: [Turtle] = try JSONDecoder().decode([Turtle].self, from: data)
        return turtles
    }
    
    func getComputerIdsBySystem(systemId: Int) async throws -> [Int] {
        let data: Data = try await turtleDAO.getComputerIdsBySystem(systemId: systemId)
        let turtleIds: [Int] = try JSONDecoder().decode([Int].self, from: data)
        return turtleIds
    }
    
    func getMessages(page: Int, pageSize: Int, types: [MessageType] = [], sources: [MessageSource] = [], sourceIds: [String] = []) async throws -> [Message] {
        let data: Data = try await messageDAO.getMessages(page: page, pageSize: pageSize, types: types, sources: sources, sourceIds: sourceIds)
        let messages: [Message] = try JSONDecoder().decode([Message].self, from: data)
        return messages
    }
    
    func getAmountOfMessages(types: [String] = [], sources: [String] = [], sourceIds: [String] = []) async throws -> Int {
        let data: Data = try await messageDAO.getAmountOfMessages(types: types, sources: sources, sourceIds: sourceIds)
        let amount: Int = try JSONDecoder().decode(Int.self, from: data)
        return amount
    }
    
    func getLocationOfTurtle(computerId: Int) async throws -> Location {
        let data: Data = try await locationDAO.getLocationOfTurtle(id: computerId)
        let location: Location = try JSONDecoder().decode(Location.self, from: data)
        return location
    }
    
    func getAllSystems() async throws -> [System] {
        let data: Data = try await systemDAO.getAllSystems()
        let systems: [System] = try JSONDecoder().decode([System].self, from: data)
        return systems
    }
    
}
