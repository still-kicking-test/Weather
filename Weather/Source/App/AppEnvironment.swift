//
//  AppEnvironment.swift
//  Weather
//
//  Created by jonathan saville on 21/03/2024.
//

import WeatherNetworkingKit

struct AppEnvironment {
    let container: InteractorContainer
    let appState: AppState
}

extension AppEnvironment {
    
    static func bootstrap(apiService: APIServiceProtocol = APIService.shared) -> AppEnvironment {

        let appState = AppState()
        let networkManager: NetworkManagerProtocol = NetworkManager(appState: appState,apiService: apiService)
        let weatherInteractor = WeatherInteractor(networkManager: networkManager)
        let locationsInteractor = LocationsInteractor(appState: appState, coreDataManager: CoreDataManager.shared)

        let interactors = InteractorContainer.Interactors(weatherInteractor: weatherInteractor, locationsInteractor: locationsInteractor)
        let interactorContainer = InteractorContainer(interactors: interactors)

        return AppEnvironment(container: interactorContainer, appState: appState)
    }
}

extension AppEnvironment {
    
    static func mocked() -> AppEnvironment {
        .bootstrap(apiService: MockAPIService())
    }
}
