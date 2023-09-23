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
    
    func GetAllComputers() async throws -> [Turtle] {
        let data: Data = try await turtleDAO.GetAllComputers()
        let turtles: [Turtle] = try JSONDecoder().decode([Turtle].self, from: data)
        return turtles
    }
    
    func GetAllCrashedTurtles() async throws -> [Turtle] {
        let turtles: [Turtle] = try await GetAllComputers()
        var crashedTurtles: [Turtle] = []
        turtles.forEach { turtle in
            if (turtle.status == "Error") {
                crashedTurtles.append(turtle)
            }
        }
        
        return crashedTurtles
    }
    
    func GetComputerById(id: Int) async throws -> Turtle {
        let data: Data = try await turtleDAO.GetComputerById(id: id)
        let turtle: Turtle = try JSONDecoder().decode(Turtle.self, from: data)
        return turtle
    }
    
    func GetComputersBySystem(systemId: Int) async throws -> [Turtle] {
        let data: Data = try await turtleDAO.GetComputersBySystem(systemId: systemId)
        let turtles: [Turtle] = try JSONDecoder().decode([Turtle].self, from: data)
        return turtles
    }
    
    func GetMessages(page: Int, pageSize: Int, types: [MessageType] = [], sources: [MessageSource] = [], sourceIds: [String] = []) async throws -> [Message] {
        let data: Data = try await messageDAO.GetMessages(page: page, pageSize: pageSize, types: types, sources: sources, sourceIds: sourceIds)
        let messages: [Message] = try JSONDecoder().decode([Message].self, from: data)
        return messages
    }
    
    func GetAmountOfMessages(types: [String] = [], sources: [String] = [], sourceIds: [String] = []) async throws -> Int {
        let data: Data = try await messageDAO.GetAmountOfMessages(types: types, sources: sources, sourceIds: sourceIds)
        let amount: Int = try JSONDecoder().decode(Int.self, from: data)
        return amount
    }
    
    func GetLocationOfTurtle(computerId: Int) async throws {
        
    }
    
    func getAllSystems() async throws -> [System] {
        let data: Data = try await systemDAO.GetAllSystems()
        let systems: [System] = try JSONDecoder().decode([System].self, from: data)
        return systems
    }
    
}
