//
//  WeatherInteractor.swift
//  Weather
//
//  Created by jonathan saville on 21/03/2024.
//

import Foundation
import Combine
import CoreLocation
import WeatherNetworkingKit

protocol WeatherInteractorProtocol {
    func loadForecasts() async
}

// MARK: - Implemetation

class WeatherInteractor: WeatherInteractorProtocol {
    
    let appState: AppState
    let apiService: APIServiceProtocol
    let locationManager: LocationManagerProtocol
    let coreDataManager: CoreDataManager

    private var cancellables = Set<AnyCancellable>()

    init(appState: AppState, apiService: APIServiceProtocol, locationManager: LocationManagerProtocol, coreDataManager: CoreDataManager) {
        self.appState = appState
        self.apiService = apiService
        self.locationManager = locationManager
        self.coreDataManager = coreDataManager
    }

    func loadForecasts() async {
        appState.changeState(to: .loading)

        let delay: CGFloat = 0.5 // set to non-zero for dev testing, then reset to 0 (or remove)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.apiService.getForecasts(locations: self.locations)
                .sink{
                    switch $0 {
                    case .failure(let error):
                        self.appState.changeState(to: .error(error))
                    case .success(let forecasts):
                        // self.appState.changeState(to: .error(NSError(domain:"", code: 300, userInfo: [NSLocalizedDescriptionKey: "Ooiiops that wwent wrong"])))
                        self.appState.changeState(to: .loaded(forecasts))
                    }
                }
                .store(in: &self.cancellables)
        }
    }
    
    private var locations: [Location] {
        var locations: [Location] = coreDataManager.locations.map { Location(from: $0) }
        
        if appState.showCurrentLocation,
           let currentLocation = locationManager.getCurrentLocation(withName: ForecastsDisplayItem.currentLocationName) {
            locations.insert(currentLocation, at: 0)
        }
        return locations
    }
}

/*
private extension Array where Element: Location {
 
    var containsCurrentLocation: Bool {
        first{ $0.name == WeatherDisplayItem.currentLocationName } != nil
    }
}
*/

private extension Location {
    convenience init(from cdLocation: CDLocation) {
        self.init(coordinates: CLLocationCoordinate2D(latitude: Double(truncating: cdLocation.latitude),
                                                      longitude: Double(truncating: cdLocation.longitude)),
                  name: cdLocation.name,
                  country: cdLocation.country,
                  state: cdLocation.state)
    }
}
