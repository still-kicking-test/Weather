//
//  LocationsInteractor.swift
//  Weather
//
//  Created by jonathan saville on 29/04/2024.
//

import Foundation
import CoreLocation

protocol LocationsInteractorProtocol {
    func shouldShowVideo(_ value: Bool)
    func shouldShowCurrentLocation(_ value: Bool)
    func deleteLocationFor(_ id: UUID)
    func moveLocationFrom(_ from: Int, to: Int)
    func loadTestData()
}

class LocationsInteractor: NSObject, LocationsInteractorProtocol {
    
    private let appState: AppState
    private let coreDataManager: CoreDataManagerProtocol
    private lazy var clLocationManager = CLLocationManager() { didSet { clLocationManager.delegate = self } }
    private let userDefaults = UserDefaults.standard

    init(appState: AppState, coreDataManager: CoreDataManagerProtocol) {
        self.appState = appState
        self.coreDataManager = coreDataManager
        super.init()
        clLocationManager.delegate = self
    }
    
    func shouldShowVideo(_ value: Bool) {
        appState.showVideo = value
        userDefaults.set(value, forKey: AppState.UserDefaultsKeys.showVideo)
    }
    
    func shouldShowCurrentLocation(_ value: Bool) {
        appState.showCurrentLocation = value
        userDefaults.set(value, forKey: AppState.UserDefaultsKeys.showCurrentLocation)
        appState.setReloadRequired()
        if value {
            clLocationManager.requestWhenInUseAuthorization()
        }
    }

    func deleteLocationFor(_ id: UUID) {
        coreDataManager.deleteLocationFor(id)
        appState.locations = coreDataManager.locations
        appState.setReloadRequired()
    }

    func moveLocationFrom(_ from: Int, to: Int) {
        coreDataManager.moveLocationFrom(from, to: to)
        appState.locations = coreDataManager.locations
        appState.setReloadRequired()
    }
    
    func loadTestData() {
        coreDataManager.loadTestData()
        appState.locations = coreDataManager.locations
        appState.setReloadRequired()
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
