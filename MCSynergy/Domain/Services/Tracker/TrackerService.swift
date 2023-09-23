//
//  TrackerService.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 03/07/2023.
//

import Foundation

class TrackerService {
    private let repo: TrackerRepository
    
    init() {
        repo = TrackerRepository()
    }
    
    func GetMessages(page: Int, pageSize: Int, types: [MessageType] = [], sources: [MessageSource] = [], sourceIds: [String] = []) async throws -> [Message] {
        return try await repo.GetMessages(page: page, pageSize: pageSize, types: types, sources: sources, sourceIds: sourceIds)
    }
    
    func GetTurtleById(id: Int) async throws -> Turtle {
        return try await repo.GetComputerById(id: id)
    }
    
    func getAllCrashedTurtles() async throws -> [Turtle] {
        return try await repo.GetAllCrashedTurtles()
    }
    
    func getTurtlesBySystem(systemId: Int) async throws -> [Turtle] {
        return try await repo.GetComputersBySystem(systemId: systemId)
    }
    
    func GetDisplayName(source: MessageSource, sourceId: String) async throws -> String {
        switch(source) {
        case .Computer, .Turtle:
            let id: Int? = Int(sourceId)
            guard let id = id else {
                return source.rawValue
            }
            return try await repo.GetComputerById(id: id).label ?? source.rawValue
            
        default:
            return source.rawValue
        }
    }
    
    func GetAmountOfMessages(types: [String] = [], sources: [String] = [], sourceIds: [String] = []) async throws -> Int {
        return try await repo.GetAmountOfMessages(types: types, sources: sources, sourceIds: sourceIds)
    }
    
    func getAllSystems() async throws -> [System]{
        return try await repo.getAllSystems()
    }
}
