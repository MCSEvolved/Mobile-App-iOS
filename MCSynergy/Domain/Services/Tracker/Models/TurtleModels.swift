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
    
    func getTimeString() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "HH:mm:ss"
        let date = Date(timeIntervalSince1970: TimeInterval(lastUpdate/1000))
        return formatter.string(from: date)
    }
    
    func getDateString(format: String = "dd/MM") -> String {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = format
        let date = Date(timeIntervalSince1970: TimeInterval(lastUpdate/1000))
        return formatter.string(from: date)
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
