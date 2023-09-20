//
//  SettingsManager.swift
//  Weather
//
//  Created by jonathan saville on 19/09/2023.
//

import Foundation

protocol SettingsManagerProtocol {
    var showCurrentLocation: Bool { get set }
    var showVideo: Bool { get set }
}

class SettingsManager: SettingsManagerProtocol {
    
    let defaults = UserDefaults.standard

    static let shared = SettingsManager()
    
    var showCurrentLocation: Bool {
        get { return defaults.object(forKey:"showCurrentLocation") as? Bool ?? true }
        set { defaults.set(newValue, forKey: "showCurrentLocation") }
    }
    
    var showVideo: Bool {
        get { return defaults.object(forKey:"showVideo") as? Bool ?? false }
        set { defaults.set(newValue, forKey: "showVideo") }
    }
}
