//
//  LocationDOA.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 03/07/2023.
//

import Foundation

class LocationDAO: DAO {
    func getLocationOfTurtle(id: Int) async throws -> Data {
        let token = try await AuthService.getToken()
        guard let token = token else {
            throw ApiError.unauthorized
        }
        let data = try await request(method: "GET", url: "/tracker/location/get/by-id?computerId=\(id)", token: token)
        return data
    }
}
