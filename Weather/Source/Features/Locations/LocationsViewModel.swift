//
//  LocationsViewModel.swift
//  Weather
//
//  Created by jonathan saville on 13/09/2023.
//

import Foundation
import Combine
import UIKit

enum LocationsDisplayItem {
    case location(value: CDLocation)
    case video(isEnabled: Bool)
    case local(isEnabled: Bool)
}

class LocationsViewModel {
    
    @Published var generalError: Error? = nil
    
    private let apiService: APIServiceProtocol
    private var locationManager: LocationManagerProtocol
    private let coreDataManager: CoreDataManager
    private var cancellables = Set<AnyCancellable>()
    private let immovableDisplayItemsCount = 2 // allows for the current-location and UK-video rows
    
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
        coreDataManager.locations.count + immovableDisplayItemsCount
    }
    
    public func displayItem(forIndex index: Int) -> LocationsDisplayItem? {
        switch index {
        case 0:
            return .local(isEnabled: locationManager.showCurrentLocation)
        case 1:
            return .video(isEnabled: locationManager.showVideo)
        default:
            let locationIndex = index - immovableDisplayItemsCount
            if coreDataManager.locations.indices.contains(locationIndex) {
                return .location(value: coreDataManager.locations[locationIndex])
            } else {
                return nil
            }
        }
    }
    
    func valueDidChangeAt(_ indexPath: IndexPath, with value: Bool) {
        switch indexPath.row {
        case 0: locationManager.showCurrentLocation = value
                if value {
                    locationManager.requestAuthorizationIfRequired()
                }
        case 1: locationManager.showVideo = value
        default: break
        }
    }

    func removeLocationAt(_ indexPath: IndexPath, shouldPersist: Bool = true) {
        coreDataManager.locations.remove(at: indexPath.row)
        if shouldPersist {
            saveChanges()
        }
    }
    
    func insertLocation(_ location: CDLocation, at indexPath: IndexPath, shouldPersist: Bool = true) {
        coreDataManager.locations.insert(location, at: indexPath.row)
        saveChanges()
    }
    
    func moveLocationAt(_ sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let sourceIndexPath = sourceIndexPath.previousRow(step: immovableDisplayItemsCount),
              let destinationIndexPath = destinationIndexPath.previousRow(step: immovableDisplayItemsCount) else { return }
              
        let location = coreDataManager.locations[sourceIndexPath.row]
        removeLocationAt(sourceIndexPath, shouldPersist: false)
        insertLocation(location, at: destinationIndexPath, shouldPersist: false)
        
        for i in 0..<coreDataManager.locations.count {
            coreDataManager.locations[i].displayOrder = Int16(i)
        }
        
        saveChanges()
    }
    
    func canMoveItemAt(_ indexPath: IndexPath) -> Bool {
        indexPath.row >= immovableDisplayItemsCount
    }

    func saveChanges() {
        coreDataManager.saveContext()
    }
}
