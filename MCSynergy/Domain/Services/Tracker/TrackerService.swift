//
//  TrackerService.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 03/07/2023.
//

import Foundation

class TrackerService {
    static var shared: TrackerService = TrackerService()
    
    private let repo: TrackerRepository
    
    init() {
        repo = TrackerRepository()
    }
    
    func getMessages(page: Int, pageSize: Int, types: [MessageType] = [], sources: [MessageSource] = [], sourceIds: [String] = []) async throws -> [Message] {
        return try await repo.getMessages(page: page, pageSize: pageSize, types: types, sources: sources, sourceIds: sourceIds)
    }
    
    func getTurtleById(id: Int) async throws -> Turtle {
        return try await repo.getComputerById(id: id)
    }
    
    func getAllCrashedTurtles() async throws -> [Turtle] {
        return try await repo.getAllCrashedTurtles()
    }
    
    func getTurtlesBySystem(systemId: Int) async throws -> [Turtle] {
        return try await repo.getComputersBySystem(systemId: systemId)
    }
    
    func getTurtleIdsBySystem(systemId: Int) async throws -> [Int] {
        return try await repo.getComputerIdsBySystem(systemId: systemId)
    }
    
    func getDisplayName(source: MessageSource, sourceId: String) async throws -> String {
        switch(source) {
        case .Computer, .Turtle:
            let id: Int? = Int(sourceId)
            guard let id = id else {
                return source.rawValue
            }
            return try await repo.getComputerById(id: id).label ?? source.rawValue
            
        default:
            return source.rawValue
        }
    }
    
    func getAmountOfMessages(types: [String] = [], sources: [String] = [], sourceIds: [String] = []) async throws -> Int {
        return try await repo.getAmountOfMessages(types: types, sources: sources, sourceIds: sourceIds)
    }
    
    func getAllSystems() async throws -> [System] {
        return try await repo.getAllSystems()
    }
    
    func getLocationOfTurtle(computerId: Int) async throws -> Location {
        return try await repo.getLocationOfTurtle(computerId: computerId)
    }
}
