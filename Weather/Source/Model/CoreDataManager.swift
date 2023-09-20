//
//  CoreDataManager.swift
//  Weather
//
//  Created by jonathan saville on 15/09/2023.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
 
    var locations: [Location] = []
    lazy var moc: NSManagedObjectContext? = appDelegate?.persistentContainer.viewContext
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    static let shared = CoreDataManager()
    
    func loadData() {
        guard let moc = moc else { return }
        
        let locationRequest: NSFetchRequest<Location> = Location.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "displayOrder", ascending: true)
        locationRequest.sortDescriptors = [sortDescriptor]
        do {
            try locations = moc.fetch(locationRequest)
            print("CoreData locations:\n")
            for location in locations { print("[displayOrder: \(location.displayOrder), name: \(location.name), lat: \(location.latitude), lon:\(location.longitude), country: \(location.country), state: \(location.state)]") }
        } catch {
            print("Could not load locations")
        }
    }
    
    func addLocation(displayOrder: Int,
                     name: String,
                     coordinates: Coordinates,
                     country: String,
                     state: String) {
        
        guard let moc = moc else { return }
        
        let locationItem = Location(context: moc)
        locationItem.displayOrder = Int16(displayOrder)
        locationItem.name = name
        locationItem.latitude = NSDecimalNumber(decimal: coordinates.latitude)
        locationItem.longitude = NSDecimalNumber(decimal: coordinates.longitude)
        locationItem.country = country
        locationItem.state = state
    }

    func saveContext() {
        appDelegate?.saveContext()
    }
}

extension CoreDataManager {
    
    // DEV ONLY
    func loadTestDataIfEmpty() {
        guard locations.isEmpty else { return }
        
        CoreDataManager.shared.addLocation(displayOrder: 0, name: "London", coordinates: (latitude: 51.4875167, longitude: -0.1687007), country: "GB", state: "England")
        CoreDataManager.shared.addLocation(displayOrder: 1, name: "Chicago", coordinates: (latitude: 41.8755616, longitude: -87.6244212), country: "US", state: "Illinois")
        CoreDataManager.shared.addLocation(displayOrder: 2, name: "Rome", coordinates: (latitude: 41.8933203, longitude: 12.4829321), country: "IT", state: "Lazio")
        CoreDataManager.shared.addLocation(displayOrder: 3, name: "Tokyo", coordinates: (latitude: 35.709674, longitude: 139.454224), country: "JP", state: "")
        CoreDataManager.shared.saveContext()
        loadData()
    }
}
