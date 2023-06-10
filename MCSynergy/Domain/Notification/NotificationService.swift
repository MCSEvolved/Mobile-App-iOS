//
//  NotificationService.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 29/05/2023.
//

import Foundation
import UserNotifications
import Firebase

class NotificationService {
    private var notificationsEnabled: Bool = false
    
    public func requestPermission(completion: @escaping (Bool, Error?) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print(error.localizedDescription)
                completion(granted, error)
            }
            
            if (granted) {
                self.notificationsEnabled = true
                
                completion(granted, error)
            } else {
                completion(granted, error)
            }
        }
    }
    
//    public func subscribe(token: String?) async -> Bool {
//        return await withCheckedContinuation { continuation in
//            guard let requestUrl = URL(string:"https://api.mcsynergy.nl/notification/register-device") else {
//                continuation.resume(returning: false)
//                return
//            }
//            
//            var request = URLRequest(url: requestUrl)
//            
//            request.httpMethod = "POST"
//            
//            guard let token = token else {
//                continuation.resume(returning: false)
//                return
//            }
//            // Create Request body!
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//            let task = URLSession.shared.dataTask(with: request) {data, _, error in
//                guard error == nil else {
//                    print("Error: \(error!.localizedDescription)")
//                    continuation.resume(returning: false)
//                    return
//                }
//                continuation.resume(returning: true)
//            }
//            task.resume()
//        }
//    }
//
    
    public func getStateOfTopic(topic: String) -> Bool {
        let state: Bool? = UserDefaults.standard.bool(forKey: topic)
        guard let state = state else {
            changeStateOfTopic(topic: topic, state: false)
            return false
        }
        changeStateOfTopic(topic: topic, state: state)
        return state
    }
    
    public func changeStateOfTopic(topic: String, state: Bool) {
        UserDefaults.standard.setValue(state, forKey: topic)
        if (state && isEnabled()) {
            Messaging.messaging().subscribe(toTopic: topic)
        } else {
            Messaging.messaging().unsubscribe(fromTopic: topic)
        }
    }
    
    public func isEnabled() -> Bool {
        return notificationsEnabled
    }
}

