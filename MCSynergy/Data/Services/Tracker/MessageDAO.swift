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
                
        let data = try await Request(method: "GET", url: "/tracker/message/get?page=\(page)&pageSize=\(pageSize)", token: token)
        return data
    }
    
    func GetAllMessagesBySource(page: Int, pageSize: Int, source: String) async throws -> Data {
        let token = try await AuthService.getToken()
        guard let token = token else {
            throw ApiError.unauthorized
        }
        let data = try await Request(method: "GET", url: "/tracker/message/get?page=\(page)&pageSize=\(pageSize)&sources=\(source)", token: token)
        return data
    }
    
    func GetAllMessagesBySourceIds(page: Int, pageSize: Int, sourceIds: [String]) async throws -> Data {
        let token = try await AuthService.getToken()
        guard let token = token else {
            throw ApiError.unauthorized
        }
        
        var url = "/tracker/message/get?page=\(page)&pageSize=\(pageSize)"
        
        for id in sourceIds {
            url += "&sourceIds=\(id)"
        }
        
        let data = try await Request(method: "GET", url: url, token: token)
        return data
    }
    
    func GetAllMessagesByTypes(page: Int, pageSize: Int, types: [String]) async throws -> Data {
        let token = try await AuthService.getToken()
        guard let token = token else {
            throw ApiError.unauthorized
        }
        var url = "/tracker/message/get?page=\(page)&pageSize=\(pageSize)"
        
        for type in types {
            url += "&types=\(type)"
        }
        
        let data = try await Request(method: "GET", url: url, token: token)
        return data
    }
    
    
    
    func GetMessages(page: Int, pageSize: Int, types: [MessageType] = [], sources: [MessageSource] = [], sourceIds: [String] = []) async throws -> Data {
        let token = try await AuthService.getToken()
        guard let token = token else {
            throw ApiError.unauthorized
        }
        var url = "/tracker/message/get?page=\(page)&pageSize=\(pageSize)"
        
        for type in types {
            url += "&types=\(type)"
        }
        
        for source in sources {
            url += "&sources=\(source)"
        }
        
        for sourceId in sourceIds {
            url += "&sourceIds=\(sourceId)"
        }
        
        let data = try await Request(method: "GET", url: url, token: token)
        return data
    }
    
    func GetAmountOfMessages(types: [String] = [], sources: [String] = [], sourceIds: [String] = []) async throws -> Data {
        let token = try await AuthService.getToken()
        guard let token = token else {
            throw ApiError.unauthorized
        }
        var url = "/tracker/message/get/amount?"
        var firstQuery = true
        
        for type in types {
            if (firstQuery) {
                url += "types=\(type)"
                firstQuery = false
            } else {
                url += "&types=\(type)"
            }
            
        }
        
        for source in sources {
            if (firstQuery) {
                url += "sources=\(source)"
                firstQuery = false
            } else {
                url += "&sources=\(source)"
            }
        }
        
        for sourceId in sourceIds {
            if (firstQuery) {
                url += "sourceIds=\(sourceId)"
                firstQuery = false
            } else {
                url += "&sourceIds=\(sourceId)"
            }
        }
        
        let data = try await Request(method: "GET", url: url, token: token)
        return data
    }
}
