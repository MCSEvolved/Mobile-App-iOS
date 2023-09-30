//
//  SystemDAO.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 03/07/2023.
//

import Foundation

class SystemDAO: DAO {
    func getAllSystems() async throws -> Data {
        let token = try await AuthService.getToken()
        guard let token = token else {
            throw ApiError.unauthorized
        }
        let data = try await request(method: "GET", url: "/mcs-api/system/get/all", token: token)
        return data
    }
    
    func getSystemById(id: Int) async throws -> Data {
        let token = try await AuthService.getToken()
        guard let token = token else {
            throw ApiError.unauthorized
        }
        let data = try await request(method: "GET", url: "/mcs-api/system/get/by-id?id=\(id)", token: token)
        return data
    }
}
