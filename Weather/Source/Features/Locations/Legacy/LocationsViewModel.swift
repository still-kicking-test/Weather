//
//  LocationsViewModel.swift
//  Weather
//
//  Created by jonathan saville on 13/09/2023.
//

import UIKit
import CoreLocation

enum LocationsDisplayItem {
    static let searchPlaceholder = "Search & save your places"
    static let videoTitle = "UK video forecast"

    case location(value: CDLocation)
    case video(isEnabled: Bool)
    case currentLocation(isEnabled: Bool)
    case search
}

class LocationsViewModel: NSObject {
    
    @Published var generalError: Error? = nil
    @Published var isUpdated = false

    private enum StaticDisplayItems: Int, CaseIterable {
        case search
        case currentLocation
        case video
    }

    private let appState: AppState
    private let coreDataManager: CoreDataManagerProtocol
    private let userDefaults = UserDefaults.standard
    private lazy var clLocationManager = CLLocationManager() { didSet { clLocationManager.delegate = self } }

    fileprivate static var staticDisplayItemsCount: Int { StaticDisplayItems.allCases.count }

    init(appState: AppState, coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.appState = appState
        self.coreDataManager = coreDataManager
        super.init()
    }

    public var displayItemsCount: Int {
        // Could use a derived data type here (locationsCount) for the count, but that would
        // require the creation of another entity just to hold that count, so a bit of an overkill.
        appState.locations.count + LocationsViewModel.staticDisplayItemsCount
    }
    
    public func displayItem(forIndex index: Int) -> LocationsDisplayItem? {
        switch index {
        case StaticDisplayItems.search.rawValue:
            return .search

        case StaticDisplayItems.currentLocation.rawValue:
            return .currentLocation(isEnabled: appState.showCurrentLocation)

        case StaticDisplayItems.video.rawValue:
            return .video(isEnabled: appState.showVideo)
        
        default:
            let locationIndex = index - LocationsViewModel.staticDisplayItemsCount
            if appState.locations.indices.contains(locationIndex) {
                return .location(value: appState.locations[locationIndex])
            } else {
                return nil
            }
        }
    }
    
    func searchTapped() {
        // Until we have a decent city search API, the search field is just a tappable button - we ask the user
        // if they want to reset the locations to the set of test locations...
        let message = "Location search is not yet implemented. Do you wish to update your locations with the set of test locations?"
        let alertController = UIAlertController(title: "Information", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "No", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Update locations", style: .destructive) { _ in
            self.coreDataManager.loadTestData()
            self.appState.locations = self.coreDataManager.locations
            self.appState.setReloadRequired()
            self.isUpdated = true
        })
        
        let topController = UIApplication.shared.topViewController()
        topController?.present(alertController, animated: true)
     }

    func valueDidChangeAt(_ indexPath: IndexPath, with value: Bool) {
        switch indexPath.row {
        case StaticDisplayItems.currentLocation.rawValue: 
            userDefaults.set(value, forKey: AppState.UserDefaultsKeys.showCurrentLocation)
            appState.showCurrentLocation = value
            appState.setReloadRequired()
            if value {
                clLocationManager.requestWhenInUseAuthorization()
            }
        case StaticDisplayItems.video.rawValue:
            userDefaults.set(value, forKey: AppState.UserDefaultsKeys.showVideo)
            appState.showVideo = value
        default: break
        }
        isUpdated = true
    }

    func deleteLocationAt(_ indexPath: IndexPath) {
        guard let indexPath = indexPath.ignoreStaticDisplayItems else { return }
        coreDataManager.deleteLocationAt(indexPath.row, shouldSaveContext: true)
        appState.locations = coreDataManager.locations
        appState.setReloadRequired()
        isUpdated = true
    }
    
    func moveLocationAt(_ sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let sourceIndexPath = sourceIndexPath.ignoreStaticDisplayItems,
              let destinationIndexPath = destinationIndexPath.ignoreStaticDisplayItems else { return }
        coreDataManager.moveLocationAt(sourceIndexPath, to: destinationIndexPath)
        appState.locations = coreDataManager.locations
        appState.setReloadRequired()
        isUpdated = true
    }
    
    func canMoveItemAt(_ indexPath: IndexPath) -> Bool {
        indexPath.row >= LocationsViewModel.staticDisplayItemsCount
    }
}


extension LocationsViewModel: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            appState.locationManagerAuthorized = true
        default:
            appState.locationManagerAuthorized = false
        }
    }
}

fileprivate extension IndexPath {
    var ignoreStaticDisplayItems: IndexPath? {
        previousRow(step: LocationsViewModel.staticDisplayItemsCount)
    }
}

// Temporary - can be removed when searchTapped no longer displays a message
private extension UIApplication {
    func topViewController() -> UIViewController? {
        var topViewController: UIViewController? = nil
        if #available(iOS 13, *) {
            for scene in connectedScenes {
                if let windowScene = scene as? UIWindowScene {
                    for window in windowScene.windows {
                        if window.isKeyWindow {
                            topViewController = window.rootViewController
                        }
                    }
                }
            }
        } else {
            topViewController = keyWindow?.rootViewController
        }
        while true {
            if let presented = topViewController?.presentedViewController {
                topViewController = presented
            } else if let navController = topViewController as? UINavigationController {
                topViewController = navController.topViewController
            } else if let tabBarController = topViewController as? UITabBarController {
                topViewController = tabBarController.selectedViewController
            } else {
                // Handle any other third party container in `else if` if required
                break
            }
        }
        return topViewController
    }
}
