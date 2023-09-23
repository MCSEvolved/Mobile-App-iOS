//
//  TurtleModel.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 02/07/2023.
//

import SwiftUI
import Foundation

struct Turtle: Codable, Identifiable {
    let id: Int
    let label: String?
    let systemId: Int
    let device: ComputerDevice
    let fuelLimit: Int?
    let status: String
    let fuelLevel: Int?
    let lastUpdate: Int64
    let hasModem: Bool
    
    func getStatusColor() -> Color {
        switch status {
        case "Error":
            return .red
        case "Manually Terminated", "Need Player", "Stopped", "Rebooting":
            return .orange
        default:
            return .green
        }
    }
}


enum ComputerDevice: String, Codable {
    case Turtle = "Turtle"
    case Advanced_Turtle = "Advanced_Turtle"
    case Computer = "Computer"
    case Advanced_Computer = "Advanced_Computer"
    case Pocket_Computer = "Pocket_Computer"
    case Advanced_Pocket_Computer = "Advanced_Pocket_Computer"
    
}
