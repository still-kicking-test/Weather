//
//  WeatherApp.swift
//  Weather
//
//  Created by jonathan saville on 19/03/2024.
//

import SwiftUI

@main
struct WeatherApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
