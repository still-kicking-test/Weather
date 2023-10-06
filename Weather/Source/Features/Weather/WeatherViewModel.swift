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
    static let currentLocationName = "\u{1F4CC} Current location"
    static let videoTitle = "UK video forecast (from archives)"

    case video(title: String, url: URL)
    case location(forecast: Forecast)
}

class WeatherViewModel: NSObject {
        
    @Published var forecast: [Forecast] = []
    @Published var isLoading: Bool = false
    @Published var generalError: Error? = nil

    private var cancellables = Set<AnyCancellable>()
    
    private let apiService: APIServiceProtocol
    private let locationManager: LocationManagerProtocol
    private let coreDataManager: CoreDataManager

    /// There is  no easy way to determine the latest MetOffice video forecast, so for the time being, hardcode an existing one...
    private let videoUrl = URL(string: "https://www.youtube.com/embed/MS8g7QYg6As?playsinline=1")!

    private var locations: [Location] {
        var locations: [Location] = coreDataManager.locations.map { Location(from: $0) }
        
        if locationManager.showCurrentLocation,
           let currentLocation = locationManager.getCurrentLocation(withName: WeatherDisplayItem.currentLocationName) {
            locations.insert(currentLocation, at: 0)
        }
        return locations
    }

    init(apiService: APIServiceProtocol,
         locationManager: LocationManagerProtocol,
         coreDataManager: CoreDataManager) {
        self.apiService = apiService
        self.locationManager = locationManager
        self.coreDataManager = coreDataManager
        super.init()
        
        observeReloadTriggers()
    }

    var displayItemCount: Int {
        forecast.count + (locationManager.showVideo ? 1 : 0)
    }

    func displayItem(forIndex index: Int) -> WeatherDisplayItem? {
        var forecastOffset = 0
        var showVideoAt: Int?
        
        if locationManager.showVideo {
            showVideoAt = locations.containsCurrentLocation ? 1 : 0
            forecastOffset = index > showVideoAt! ? 1 : 0
        }
        
        if index == showVideoAt {
            return .video(title: WeatherDisplayItem.videoTitle, url: videoUrl)
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

        locationManager.authorizedPublisher
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] _ in
                self?.loadForecasts()
            }
            .store(in: &cancellables)

        locationManager.showVideoPublisher
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] _ in
                self?.loadForecasts()
            }
            .store(in: &cancellables)

        locationManager.showCurrentLocationPublisher
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] _ in
                self?.loadForecasts()
            }
            .store(in: &cancellables)
    }
}

private extension Array where Element: Location {
 
    var containsCurrentLocation: Bool {
        first{ $0.name == WeatherDisplayItem.currentLocationName } != nil
    }
}
