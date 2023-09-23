//
//  ServiceDAO.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 03/07/2023.
//

import Foundation

class ServiceDAO: DAO {
    func GetAllServices() async throws -> Data {
        let token = try await AuthService.getToken()
        guard let token = token else {
            throw ApiError.unauthorized
        }
        let data = try await Request(method: "GET", url: "/mcs-api/service/get/all", token: token)
        return data
    }
    
    func GetServiceByName(name: String) async throws -> Data {
        let token = try await AuthService.getToken()
        guard let token = token else {
            throw ApiError.unauthorized
        }
        let data = try await Request(method: "GET", url: "/mcs-api/service/get/by-name?name=\(name)", token: token)
        return data
    }
}
