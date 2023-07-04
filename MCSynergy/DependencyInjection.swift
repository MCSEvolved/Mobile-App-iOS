//
//  DependencyContainer.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 04/07/2023.
//

import Foundation

class Container {
    static let shared: Container = Container()
    
    private lazy var authService: AuthService = AuthService()
    func resolveAuthService() -> AuthService {
        return authService
    }
    
    private lazy var notificationService: NotificationService = NotificationService()
    func resolveNotificationService() -> NotificationService {
        return notificationService
    }
    
    private lazy var trackerService: TrackerService = TrackerService()
    func resolveTrackerService() -> TrackerService {
        return trackerService
    }
}
