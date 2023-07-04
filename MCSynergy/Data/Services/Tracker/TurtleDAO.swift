//
//  TurtlesDOA.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 03/07/2023.
//

import Foundation

class TurtleDAO: DAO {
    
    func GetAllComputers() async throws -> Data {
        let token = try await AuthService.getToken()
        guard let token = token else {
            throw ApiError.unauthorized
        }
        let data = try await Request(method: "GET", url: "/tracker/computer/get/all", token: token)
        return data
    }
    
    func GetComputerById(id: Int) async throws -> Data {
        let token = try await AuthService.getToken()
        guard let token = token else {
            throw ApiError.unauthorized
        }
        let data = try await Request(method: "GET", url: "/tracker/computer/get/by-id?id=\(id)", token: token)
        return data
    }
    
    func GetComputersBySystem(systemId: Int) async throws -> Data {
        let token = try await AuthService.getToken()
        guard let token = token else {
            throw ApiError.unauthorized
        }
        let data = try await Request(method: "GET", url: "/tracker/computer/get/by-system?systemId=\(systemId)", token: token)
        return data
    }
}
