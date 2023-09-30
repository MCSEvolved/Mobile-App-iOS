//
//  TurtlesDOA.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 03/07/2023.
//

import Foundation

class TurtleDAO: DAO {
    
    func getAllComputers() async throws -> Data {
        let token = try await AuthService.getToken()
        guard let token = token else {
            throw ApiError.unauthorized
        }
        let data = try await request(method: "GET", url: "/tracker/computer/get/all", token: token)
        return data
    }
    
    func getComputerById(id: Int) async throws -> Data {
        let token = try await AuthService.getToken()
        guard let token = token else {
            throw ApiError.unauthorized
        }
        let data = try await request(method: "GET", url: "/tracker/computer/get/by-id?id=\(id)", token: token)
        return data
    }
    
    func getComputersBySystem(systemId: Int) async throws -> Data {
        let token = try await AuthService.getToken()
        guard let token = token else {
            throw ApiError.unauthorized
        }
        let data = try await request(method: "GET", url: "/tracker/computer/get/by-system?systemId=\(systemId)", token: token)
        return data
    }
    
    func getComputerIdsBySystem(systemId: Int) async throws -> Data {
        let token = try await AuthService.getToken()
        guard let token = token else {
            throw ApiError.unauthorized
        }
        let data = try await request(method: "GET", url: "/tracker/computer/get/by-system?systemId=\(systemId)&idsOnly=true", token: token)
        return data
    }
}
