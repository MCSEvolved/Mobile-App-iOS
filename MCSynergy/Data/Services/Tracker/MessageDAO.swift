//
//  MessagesDOA.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 03/07/2023.
//

import Foundation

class MessageDAO: DAO {
    func GetAllMessages(page: Int, pageSize: Int) async throws -> Data {
        let token = try await AuthService.getToken()
        guard let token = token else {
            throw ApiError.unauthorized
        }
        let data = try await Request(method: "GET", url: "/tracker/message/get/all?page=\(page)&pageSize=\(pageSize)", token: token)
        return data
    }
    
    func GetAllMessagesBySource(page: Int, pageSize: Int) async throws -> Data {
        let token = try await AuthService.getToken()
        guard let token = token else {
            throw ApiError.unauthorized
        }
        let data = try await Request(method: "GET", url: "/tracker/message/get/by-source?page=\(page)&pageSize=\(pageSize)", token: token)
        return data
    }
    
    func GetAllMessagesBySourceIds(page: Int, pageSize: Int, sourceIds: [String]) async throws -> Data {
        let token = try await AuthService.getToken()
        guard let token = token else {
            throw ApiError.unauthorized
        }
        let data = try await Request(method: "GET", url: "/tracker/message/get/by-source-ids?page=\(page)&pageSize=\(pageSize)&sourceIds[]=\(sourceIds)", token: token)
        return data
    }
    
    func GetAllMessagesByType(page: Int, pageSize: Int, type: String) async throws -> Data {
        let token = try await AuthService.getToken()
        guard let token = token else {
            throw ApiError.unauthorized
        }
        let data = try await Request(method: "GET", url: "/tracker/message/get/all?page=\(page)&pageSize=\(pageSize)&type=\(type)", token: token)
        return data
    }
}
