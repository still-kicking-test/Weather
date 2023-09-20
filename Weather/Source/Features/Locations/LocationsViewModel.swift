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
    case location(value: Location)
    case video(isEnabled: Bool)
    case current(isEnabled: Bool)
}

class LocationsViewModel {
    
    @Published var generalError: Error? = nil
    
    private let apiService: APIServiceProtocol
    private let coreDataManager: CoreDataManager
    private var cancellables = Set<AnyCancellable>()
    private let settingsManager: SettingsManagerProtocol
    private let immovableDisplayItemsCount = 2 // allows for the current-location and UK-video rows
    
    init(apiService: APIServiceProtocol = APIService.shared,
         settingsManager: SettingsManagerProtocol = SettingsManager.shared,
         coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.apiService = apiService
        self.settingsManager = settingsManager
        self.coreDataManager = coreDataManager
    }
    
    public var displayItemsCount: Int {
        coreDataManager.locations.count + immovableDisplayItemsCount
    }
    
    public func displayItem(forIndex index: Int) -> LocationsDisplayItem? {
        switch index {
        case 0:
            return .current(isEnabled: settingsManager.showCurrentLocation)
        case 1:
            return .video(isEnabled: settingsManager.showVideo)
        default:
            let locationIndex = index - immovableDisplayItemsCount
            if coreDataManager.locations.indices.contains(locationIndex) {
                return .location(value: coreDataManager.locations[locationIndex])
            } else {
                return nil
            }
        }
    }
    
    func removeLocationAt(_ indexPath: IndexPath, shouldPersist: Bool = true) {
        coreDataManager.locations.remove(at: indexPath.row)
        if shouldPersist {
            saveChanges()
        }
    }
    
    func insertLocation(_ location: Location, at indexPath: IndexPath, shouldPersist: Bool = true) {
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
