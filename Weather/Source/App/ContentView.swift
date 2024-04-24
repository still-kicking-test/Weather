//
//  ContentView.swift
//  Weather
//
//  Created by jonathan saville on 19/03/2024.
//

import SwiftUI

struct ContentView: View {

    private let appEnvironment: AppEnvironment
    
    init() {
        appEnvironment = SettingsBundleHelper.shared.isAPIMocked ? AppEnvironment.mocked() : AppEnvironment.bootstrap()
    }
    
    var body: some View {
        TabView {
            Group {
                WeatherView()
                    .tabItem {
                        Label("Weather", systemImage: "cloud.sun")
                            .environment(\.symbolVariants, .none)
                    }
                
                MapsView()
                    .tabItem {
                        Label("Maps", systemImage: "map")
                            .environment(\.symbolVariants, .none)
                    }
                
                WarningsView()
                    .tabItem {
                        Label("Warnings", systemImage: "exclamationmark.triangle")
                            .environment(\.symbolVariants, .none)
                    }
            }
            .toolbarBackground(Color.backgroundSecondary.opacity(0.7), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .environmentObject(appEnvironment.appState)
        .environment(\.injected, appEnvironment.container)
     }
}

struct ContentView_Previews: PreviewProvider {
    static let appEnvironment = AppEnvironment.mocked()

    static var previews: some View {
        ContentView()
   }
}
