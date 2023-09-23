//
//  MessageModel.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 03/07/2023.
//

import Foundation
import SwiftUI

struct JSON: Codable {
  var value: Any?

  public init(from decoder: Decoder) throws {
    self.value = 0
  }

  public func encode(to encoder: Encoder) throws {
  }
}


struct Message: Identifiable, Codable {
    
    let id: String
    let type: MessageType
    let source: MessageSource
    let content: String
    let metaData: JSON?
    let sourceId: String
    let creationTime: Int64

    
    func getTimeString() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "HH:mm:ss"
        let date = Date(timeIntervalSince1970: TimeInterval(creationTime/1000))
        return formatter.string(from: date)
    }
    
    func getDateString() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "dd/MM"
        let date = Date(timeIntervalSince1970: TimeInterval(creationTime/1000))
        return formatter.string(from: date)
    }
    
    func getStatusColor() -> Color {
        switch type {
        case .Debug:
            return .gray
        case .Error:
            return .red
        case .Warning:
            return .orange
        case .Info:
            return .green
        default:
            return .green
        }
    }
    
    func getDisplayName() -> String {
        let trackerService: TrackerService = Container.shared.resolveTrackerService()
        Task.init {
            do {
                let displayName: String = try await trackerService.GetDisplayName(source: self.source, sourceId: self.sourceId)
                return displayName
            } catch {
                print(String(describing: error))
                return "\(self.source.rawValue) \(self.sourceId)"
            }
        }
        return "\(self.source.rawValue) \(self.sourceId)"
        
       
    }
    
}

enum MessageType: String, Codable {
    case Error = "Error"
    case Warning = "Warning"
    case Info = "Info"
    case Debug = "Debug"
    case OutOfFuel = "OutOfFuel"
}

enum MessageSource: String, Codable {
    case Service = "Service"
    case Computer = "Computer"
    case Turtle = "Turtle"
    case System = "System"
}
