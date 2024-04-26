//
//  NetworkManager.swift
//  Weather
//
//  Created by jonathan saville on 21/03/2024.
//
//  NOTE - when the API is mocked, ensure that the simulator's location (set in Features->Location) is set to 'Apple' as that is the mocked current location.
//

import Combine
import CoreLocation
import WeatherNetworkingKit

protocol NetworkManagerProtocol {
    func loadForecasts() async
}

// MARK: - Implemetation

class NetworkManager: NetworkManagerProtocol {
    
    let appState: AppState
    let apiService: APIServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(appState: AppState, apiService: APIServiceProtocol) {
        self.appState = appState
        self.apiService = apiService
    }

    func loadForecasts() async {
        let locations = self.locations

        guard locations.isEmpty == false else {
            appState.changeState(to: .loaded([], isReloadRequired: false))
            return
        }

        appState.changeState(to: .loading)

        let delay: CGFloat = 0.5 // set to non-zero for dev testing, then reset to 0 (or remove)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.apiService.getForecasts(locations: locations)
                .sink{
                    switch $0 {
                    case .failure(let error):
                        self.appState.changeState(to: .error(error))
                    case .success(let forecasts):
                        self.appState.changeState(to: .loaded(forecasts, isReloadRequired: false))
                    }
                }
                .store(in: &self.cancellables)
        }
    }
    
    private var locations: [Location] {
        var locations: [Location] = appState.locations.map { Location(from: $0) }
        
        if appState.showCurrentLocation,
           let currentLocation = getCurrentLocation(withName: CommonStrings.currentLocation) {
            locations.insert(currentLocation, at: 0)
        }
        return locations
    }
    
    private func getCurrentLocation(withName name: String) -> Location? {
        let locationManager = CLLocationManager()
        switch CLLocationManager().authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            guard let currentLocation = locationManager.location else { return nil }
            return Location(coordinates: currentLocation.coordinate, name: name)
        default:
            return nil
        }
    }
}

private extension Location {
    convenience init(from cdLocation: CDLocation) {
        self.init(coordinates: CLLocationCoordinate2D(latitude: Double(truncating: cdLocation.latitude),
                                                      longitude: Double(truncating: cdLocation.longitude)),
                  name: cdLocation.name,
                  country: cdLocation.country,
                  state: cdLocation.state)
    }
}
