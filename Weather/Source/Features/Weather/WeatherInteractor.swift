//
//  WeatherInteractor.swift
//  Weather
//
//  Created by jonathan saville on 21/03/2024.
//

protocol WeatherInteractorProtocol {
    func loadForecasts()
}

// MARK: - Implemetation

class WeatherInteractor: WeatherInteractorProtocol {
    
    let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func loadForecasts() {
        Task { await networkManager.loadForecasts() }
    }
}
