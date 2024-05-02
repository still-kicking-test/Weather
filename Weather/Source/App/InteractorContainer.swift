//
//  InteractorContainer.swift
//  Weather
//
//  Created by jonathan saville on 22/03/2024.
//

import SwiftUI

struct InteractorContainer: EnvironmentKey {
    let interactors: Interactors
    
    init(interactors: Interactors) {
        self.interactors = interactors
    }
    
    static var defaultValue: Self {
        let appState = AppState()
        let interactors: Interactors = .stub(appState)
        return Self(interactors: interactors)
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
        let locationsInteractor: LocationsInteractor

        init(weatherInteractor: WeatherInteractor,
             locationsInteractor: LocationsInteractor) {
            self.weatherInteractor = weatherInteractor
            self.locationsInteractor = locationsInteractor
        }
        
        static func stub(_ appState: AppState) -> Self {
            .init(weatherInteractor: WeatherInteractor(networkManager: NetworkManager.stub),
                  locationsInteractor: LocationsInteractor(appState: appState, coreDataManager: CoreDataManager.shared))
        }
    }
}
