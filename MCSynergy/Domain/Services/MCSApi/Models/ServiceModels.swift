//
//  ServiceModels.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 04/07/2023.
//

import Foundation

struct Service: Identifiable, Codable {
    var id: String
    let name: String
    let displayName: String
    let images: [ImageModel]
}

struct ImageModel: Codable {
    let name: String
    let path: String
}
