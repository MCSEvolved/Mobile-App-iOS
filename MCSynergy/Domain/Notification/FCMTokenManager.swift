//
//  FCMTokenManager.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 09/06/2023.
//

import Foundation

class FCMTokenManager {

    static let shared = FCMTokenManager()

    private enum UserDefaultKey: String {
        case fcmToken
    }

    var currentToken: String? {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKey.fcmToken.rawValue)
        }

        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKey.fcmToken.rawValue)
        }
    }
}
