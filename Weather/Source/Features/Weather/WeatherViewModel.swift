//
//  WeatherViewModel.swift
//  Weather
//
//  Created by jonathan saville on 31/08/2023.
//
import Foundation
import Combine
import CoreLocation
import UIKit

enum WeatherDisplayItem {
    case video(url: URL)
    case location(forecast: Forecast)
}

class WeatherViewModel: NSObject {
        
    @Published var forecast: [Forecast] = []
    @Published var isLoading: Bool = false
    @Published var generalError: Error? = nil

    private let apiService: APIServiceProtocol
    private let settingsManager: SettingsManagerProtocol
    private let coreDataManager: CoreDataManager
    private var cancellables = Set<AnyCancellable>()
    private let videoUrl = URL(string: "https://bbc.co.uk")!
    
    private var locations: [Location] {
        var locations: [Location] = coreDataManager.locations.map { Location(from: $0) }
        locations.injectCurrentLocationIfRequired()
        return locations
    }

    init(apiService: APIServiceProtocol = APIService.shared,
         settingsManager: SettingsManagerProtocol = SettingsManager.shared,
         coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.apiService = apiService
        self.settingsManager = settingsManager
        self.coreDataManager = coreDataManager
        super.init()
        
        observeReloadTriggers()
    }

    var displayItemCount: Int {
        forecast.count + (settingsManager.showVideo ? 1 : 0)
    }

    func displayItem(forIndex index: Int) -> WeatherDisplayItem? {
        var forecastOffset = 0
        var showVideoAt: Int?
        
        if settingsManager.showVideo {
            showVideoAt = settingsManager.showCurrentLocation && LocationManager.shared.authorized ? 1 : 0
            forecastOffset = index > showVideoAt! ? 1 : 0
        }
        
        if index == showVideoAt {
            return .video(url: videoUrl)
        }

        guard forecast.indices.contains(index - forecastOffset) else { return nil }
        return .location(forecast: forecast[index - forecastOffset])
    }

    @objc
    private func loadForecasts() {
        isLoading = true
        let delay: CGFloat = 0.5 // set to non-zero for dev testing, then reset to 0 (or remove)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.apiService.getForecasts(locations: self.locations)
                .sink{
                    self.isLoading = false
                    switch $0 {
                    case .failure(let error): self.generalError = error
                    case .success(let value): self.forecast = value
                    }
                }
                .store(in: &self.cancellables)
        }
    }

    private func observeReloadTriggers() {
        // Simple observations of a Notification triggered when either CoreData (i.e. the set of location) is changed
        // or when the Settings options (show video, etc.) are changed. To keep things simple, we simply refresh
        // the whole screen with an API call. Nice and clean...
        NotificationCenter.default.addObserver(self, selector: #selector(loadForecasts), name: .coreDataSaved, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadForecasts), name: UIApplication.willEnterForegroundNotification, object: nil)

        LocationManager.shared.$authorized
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] _ in
                self?.loadForecasts()
            }
            .store(in: &cancellables)

        SettingsManager.shared.$shouldShowVideo
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] _ in
                self?.loadForecasts()
            }
            .store(in: &cancellables)

        SettingsManager.shared.$shouldShowCurrentLocation
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] _ in
                self?.loadForecasts()
            }
            .store(in: &cancellables)
    }
}

private extension Array where Element == Location {
 
    mutating func injectCurrentLocationIfRequired() {
        guard SettingsManager.shared.showCurrentLocation,
              let currentLocation = LocationManager.shared.getCurrentLocation(withName: "Current Location") else { return }
        
        insert(currentLocation, at: 0)
    }
}
