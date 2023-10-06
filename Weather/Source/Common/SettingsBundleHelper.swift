//
//  SettingsBundleHelper.swift
//  Weather
//
//  Created by jonathan saville on 05/10/2023.
//

import Foundation

class SettingsBundleHelper {
    
    enum Keys {
        static let mocked = "MOCKED_KEY"
    }

    public static var shared = SettingsBundleHelper()
    private init() {}
    
    var isAPIMocked: Bool {
        UserDefaults.standard.bool(forKey: Keys.mocked)
    }
}
