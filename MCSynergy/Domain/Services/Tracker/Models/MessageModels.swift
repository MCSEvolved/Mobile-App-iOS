//
//  MessageModel.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 03/07/2023.
//

import Foundation

struct Message {
    let type: MessageType
    let source: MessageSource
    let content: String
    let metaData: String? //json?
    let sourceId: String
    let creationTime: Int64
}

enum MessageType: Codable {
    case Error
    case Warning
    case Info
    case Debug
    case OutOfFuel
}

enum MessageSource: Codable {
    case Service
    case Computer
    case Turtle
    case System
}
