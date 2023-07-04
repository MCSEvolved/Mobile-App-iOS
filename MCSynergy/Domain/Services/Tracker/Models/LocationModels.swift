//
//  LocationModel.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 03/07/2023.
//

import Foundation

struct Location: Codable {
    let computerId: Int
    let coordinates: Coordinates
    let dimension: String
    let createdOn: Int64
}

struct Coordinates: Codable {
    let x: Int
    let y: Int
    let z: Int
}
