//
//  SettingsManager.swift
//  Weather
//
//  Created by jonathan saville on 19/09/2023.
//

import Foundation
import Combine

protocol SettingsManagerProtocol {
    var showCurrentLocation: Bool { get set }
    var showVideo: Bool { get set }
}

class SettingsManager: SettingsManagerProtocol {
    
    @Published var shouldShowVideo: Bool = false
    @Published var shouldShowCurrentLocation: Bool = false

    enum Keys {
        static let showVideo = "showVideo"
        static let showCurrentLocation = "showCurrentLocation"
    }

    static let shared = SettingsManager()
    private var defaults = UserDefaults.standard

    private init() { }
 
    var showCurrentLocation: Bool {
        get { return defaults.object(forKey: Keys.showCurrentLocation) as? Bool ?? false }
        set {
            defaults.set(newValue, forKey: Keys.showCurrentLocation)
            shouldShowCurrentLocation = newValue

            if newValue {
                LocationManager.shared.requestAuthorizationIfRequired()
            }
        }
    }
    
    var showVideo: Bool {
        get { return defaults.object(forKey: Keys.showVideo) as? Bool ?? false }
        set { defaults.set(newValue, forKey: Keys.showVideo)
              shouldShowVideo = newValue
        }
    }
}
