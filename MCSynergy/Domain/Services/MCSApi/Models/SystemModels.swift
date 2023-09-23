//
//  SystemModels.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 04/07/2023.
//

import Foundation

struct System: Identifiable, Codable {
    var id: Int
    let displayName: String
    let description: String?
    let produces: [String]
}
