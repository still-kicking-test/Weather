//
//  LocationsViewModel.swift
//  Weather
//
//  Created by jonathan saville on 13/09/2023.
//

import Foundation
import Combine
import UIKit
import WeatherNetworkingKit

enum LocationsDisplayItem {
    case location(value: CDLocation)
    case video(isEnabled: Bool)
    case currentLocation(isEnabled: Bool)
}

class LocationsViewModel {
    
    @Published var generalError: Error? = nil
    
    private let apiService: APIServiceProtocol
    private var locationManager: LocationManagerProtocol
    private let coreDataManager: CoreDataManager
    private var cancellables = Set<AnyCancellable>()
    
    private enum StaticDisplayItems: Int, CaseIterable {
        case currentLocation
        case video
    }

    fileprivate static var staticDisplayItemsCount: Int { StaticDisplayItems.allCases.count }

    init(apiService: APIServiceProtocol,
         locationManager: LocationManagerProtocol,
         coreDataManager: CoreDataManager) {
        self.apiService = apiService
        self.locationManager = locationManager
        self.coreDataManager = coreDataManager
    }
    
    public var displayItemsCount: Int {
        // Could use a derived data type here (locationsCount) for the count, but that would
        // require the creation of another entity just to hold that count, so a bit of an overkill.
        coreDataManager.locations.count + LocationsViewModel.staticDisplayItemsCount
    }
    
    public func displayItem(forIndex index: Int) -> LocationsDisplayItem? {
        switch index {
        case StaticDisplayItems.currentLocation.rawValue:
            return .currentLocation(isEnabled: locationManager.showCurrentLocation)

        case StaticDisplayItems.video.rawValue:
            return .video(isEnabled: locationManager.showVideo)
        
        default:
            let locationIndex = index - LocationsViewModel.staticDisplayItemsCount
            if coreDataManager.locations.indices.contains(locationIndex) {
                return .location(value: coreDataManager.locations[locationIndex])
            } else {
                return nil
            }
        }
    }
    
    func valueDidChangeAt(_ indexPath: IndexPath, with value: Bool) {
        switch indexPath.row {
        case StaticDisplayItems.currentLocation.rawValue: locationManager.showCurrentLocation = value
                if value {
                    locationManager.requestAuthorizationIfRequired()
                }
        case StaticDisplayItems.video.rawValue: locationManager.showVideo = value
        default: break
        }
    }

    func deleteLocationAt(_ indexPath: IndexPath) {
        guard let indexPath = indexPath.ignoreStaticDisplayItems else { return }
        coreDataManager.deleteLocationAt(indexPath.row)
        saveChanges()
    }
    
    func insertLocation(_ location: CDLocation, at indexPath: IndexPath, shouldPersist: Bool = true) {
        guard let indexPath = indexPath.ignoreStaticDisplayItems else { return }
        coreDataManager.locations.insert(location, at: indexPath.row)
        saveChanges()
    }
    
    func moveLocationAt(_ sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let sourceIndexPath = sourceIndexPath.ignoreStaticDisplayItems,
              let destinationIndexPath = destinationIndexPath.ignoreStaticDisplayItems else { return }
              
        let location = coreDataManager.locations[sourceIndexPath.row]
        coreDataManager.locations.remove(at: sourceIndexPath.row)
        coreDataManager.locations.insert(location, at: destinationIndexPath.row)
 
        for i in 0..<coreDataManager.locations.count {
            coreDataManager.locations[i].displayOrder = Int16(i)
        }
        
        saveChanges()
    }
    
    func canMoveItemAt(_ indexPath: IndexPath) -> Bool {
        indexPath.row >= LocationsViewModel.staticDisplayItemsCount
    }

    func saveChanges() {
        coreDataManager.saveContext()
    }
}

fileprivate extension IndexPath {
    var ignoreStaticDisplayItems: IndexPath? {
        previousRow(step: LocationsViewModel.staticDisplayItemsCount)
    }
}
