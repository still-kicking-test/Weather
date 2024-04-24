//
//  LocationsInteractor.swift
//  Weather
//
//  Created by jonathan saville on 21/03/2024.
//

import CoreLocation

protocol LocationsInteractorProtocol {
    func shouldShowVideo(_ value: Bool)
    func shouldShowCurrentLocation(_ value: Bool)
    func deleteLocationAt(_ row: Int)
    func saveContext()
    func loadTestData()
}

class LocationsInteractor: NSObject, LocationsInteractorProtocol {
    
    private let appState: AppState
    private let networkManager: NetworkManagerProtocol
    private let coreDataManager: CoreDataManagerProtocol
    private let clLocationManager = CLLocationManager()
    
    init(appState: AppState, networkManager: NetworkManagerProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.appState = appState
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
        super.init()
        clLocationManager.delegate = self
    }
    
    func shouldShowVideo(_ value: Bool) {
        appState.showVideo = value
    }
    
    func shouldShowCurrentLocation(_ value: Bool) {
        appState.showCurrentLocation = value
        if value {
            requestAuthorizationIfRequired()
        }
        Task { await networkManager.loadForecasts() }
    }

    func deleteLocationAt(_ row: Int) {
        coreDataManager.deleteLocationAt(row)
    }

    func saveContext() {
        Task {
            coreDataManager.saveContext()
            await networkManager.loadForecasts()
        }
    }

    func loadTestData() {
        coreDataManager.loadTestData()
    }

    private func requestAuthorizationIfRequired() {
        clLocationManager.requestWhenInUseAuthorization()
    }
}

extension LocationsInteractor: CLLocationManagerDelegate {
 
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            appState.locationManagerAuthorized = true
        default:
            appState.locationManagerAuthorized = false
        }
    }
}
