//
//  UserDefaults+Extension.swift
//  Tracker
//
//  Created by Alexander Bralnin on 08.11.2024.
//

import Foundation


extension UserDefaults {
    
    enum SettingsKey: String {
        case isOnboarded
    }
    
    var isOnboarded: Bool {
        get {
            getSetting(key: .isOnboarded)
        }
        set {
            saveSetting(key: .isOnboarded, value: newValue)
        }
    }
    
    private func saveSetting(key: SettingsKey, value: Bool) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    private func getSetting(key: SettingsKey) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
}

