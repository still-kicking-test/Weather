//
//  InteractorContainer.swift
//  Weather
//
//  Created by jonathan saville on 22/03/2024.
//

import SwiftUI

struct InteractorContainer: EnvironmentKey {
    let interactors: Interactors
    
    init(appState: AppState, interactors: Interactors) {
        self.interactors = interactors
    }
    
    static var defaultValue: Self {
        let appState = AppState()
        let interactors: Interactors = .stub(appState)
        return Self(appState: appState, interactors: interactors)
    }
}

extension EnvironmentValues {
    var injected: InteractorContainer {
        get { self[InteractorContainer.self] }
        set { self[InteractorContainer.self] = newValue }
    }
}

extension InteractorContainer {
    struct Interactors {
        let weatherInteractor: WeatherInteractor

        init(weatherInteractor: WeatherInteractor) {
            self.weatherInteractor = weatherInteractor
        }
        
        static func stub(_ appState: AppState) -> Self {
            .init(weatherInteractor: WeatherInteractor(networkManager: NetworkManager.stub))
        }
    }
}
