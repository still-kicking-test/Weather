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
import WeatherNetworkingKit

enum WeatherDisplayItem {
    static let currentLocationName = "\u{1F4CC} Current location"

    case video(title: String, url: URL)
    case location(forecast: Forecast)
    case inlineMessage(message: InlineMessage)
}

class WeatherViewModel: NSObject {
        
    @Published var forecast: [Forecast] = []
    @Published var isLoading: Bool = false
    @Published var generalError: Error? = nil

    private var cancellables = Set<AnyCancellable>()
    
    private let apiService: APIServiceProtocol
    private let locationManager: LocationManagerProtocol
    private let coreDataManager: CoreDataManager
    private var inlineMessage: InlineMessage?
    
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
                       + (inlineMessage != nil ? 1 : 0)
    }

    func displayItem(forIndex index: Int) -> WeatherDisplayItem? {
        var forecastOffset = 0

        if let inlineMessage = inlineMessage {
            let showInlineMessageAt = 0  // always show an inline message in the first cell
            if index == showInlineMessageAt {
                return .inlineMessage(message: inlineMessage)
            }
            forecastOffset = 1
        }
        
        if locationManager.showVideo {
            let showVideoAt = forecastOffset + (locations.containsCurrentLocation ? 1 : 0)
            if index == showVideoAt {
                /// There is  no easy way to determine the latest MetOffice video forecast, so for the time being, hardcode an existing one...
                let videoUrl = URL(string: "https://www.youtube.com/embed/UxFyCqJoOpE?playsinline=1")!
                let videoTitle = "UK video forecast (from archives)"

                return .video(title: videoTitle, url: videoUrl)
            }
            forecastOffset += index > showVideoAt ? 1 : 0
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
                    self.inlineMessage = nil
                    switch $0 {
                    case .failure(let error): self.generalError = error
                    case .success(let value): 
                        if value.isEmpty {
                            self.inlineMessage = .noSummariesToDisplay
                        }
                        self.forecast = value
                    }
                }
                .store(in: &self.cancellables)
        }
    }

    private func observeReloadTriggers() {
        // Simple observations of a Notification triggered when either CoreData (i.e. the set of locations) is changed
        // or when one of the Settings options (show video, etc.) is changed. To keep things simple, we simply refresh
        // the whole screen with an API call. Nice and clean...
        NotificationCenter.default.addObserver(self, selector: #selector(loadForecasts), name: .locationDataSaved, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadForecasts), name: UIApplication.willEnterForegroundNotification, object: nil)

        locationManager.authorizedPublisher
            .dropFirst()
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

private extension Location {
    convenience init(from cdLocation: CDLocation) {
        self.init(coordinates: CLLocationCoordinate2D(latitude: Double(truncating: cdLocation.latitude),
                                                      longitude: Double(truncating: cdLocation.longitude)),
                  name: cdLocation.name,
                  country: cdLocation.country,
                  state: cdLocation.state)
    }
}
