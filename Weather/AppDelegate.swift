//
//  AppDelegate.swift
//  Weather
//
//  Created by jonathan saville on 31/08/2023.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerSettingsBundleDefaults()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    /// Will do nothing if the Settings bundle is not found (i.e. if the app is a Production release)
    private func registerSettingsBundleDefaults() {
        let userDefaults = UserDefaults.standard

        let pathStr = Bundle.main.bundlePath
        let settingsBundlePath = (pathStr as NSString).appendingPathComponent("Settings.bundle")
        let finalPath = (settingsBundlePath as NSString).appendingPathComponent("Root.plist")
        let settingsDict = NSDictionary(contentsOfFile: finalPath)
        guard let preferenceSpecifiers = settingsDict?.object(forKey: "PreferenceSpecifiers") as? [[String: Any]] else {
            return
        }

        var defaults = [String: Any]()

        for item in preferenceSpecifiers {
            guard let key = item["Key"] as? String else { continue }
            defaults[key] = item["DefaultValue"]
        }
        userDefaults.register(defaults: defaults)
    }
}
