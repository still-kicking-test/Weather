//
//  CoreDataManager.swift
//  Weather
//
//  Created by jonathan saville on 15/09/2023.
//

import CoreData

protocol CoreDataManagerProtocol {
    func deleteLocationAt(_ row: Int, shouldSaveContext: Bool)
    func moveLocationAt(_ sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    var locations: [CDLocation] { get }
#if DEBUG
    func loadTestData()
#endif
}

class CoreDataManager: CoreDataManagerProtocol  {
    
    public static let shared: CoreDataManagerProtocol = CoreDataManager()
    
    private lazy var moc: NSManagedObjectContext? = persistentContainer.viewContext
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Weather")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var locations: [CDLocation] = []
    
    private init() {
        loadData()
    }

    // MARK: - Core Data Saving support

    func deleteLocationAt(_ row: Int, shouldSaveContext: Bool = false) {
        guard let moc = moc,
              let managedObject = locations[safe: row] else { return }
        locations.remove(at: row)
        moc.delete(managedObject)

        if shouldSaveContext {
            saveContext()
        }
    }

    func addLocation(displayOrder: Int,
                     name: String,
                     latitude: Decimal,
                     longitude: Decimal,
                     country: String,
                     state: String,
                     shouldSaveContext: Bool = false) {
        
        guard let moc = moc else { return }
        
        let locationItem = CDLocation(context: moc)
        locationItem.displayOrder = Int16(displayOrder)
        locationItem.name = name
        locationItem.latitude = NSDecimalNumber(decimal: latitude)
        locationItem.longitude = NSDecimalNumber(decimal: longitude)
        locationItem.country = country
        locationItem.state = state
        
        if shouldSaveContext {
            saveContext()
        }
    }

    func moveLocationAt(_ sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let location = locations[safe: sourceIndexPath.row] else { return }
        locations.remove(at: sourceIndexPath.row)
        locations.insert(location, at: destinationIndexPath.row)
 
        for i in 0..<locations.count {
            locations[i].displayOrder = Int16(i)
        }
        saveContext()
    }

    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    private func loadData() {
        guard let moc = moc else { return }
        
        let locationRequest: NSFetchRequest<CDLocation> = CDLocation.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "displayOrder", ascending: true)
        locationRequest.sortDescriptors = [sortDescriptor]
        // locationRequest.predicate = NSPredicate(format: "name BEGINSWITH %@", "L")
        do {
            try locations = moc.fetch(locationRequest)
            // print("CoreData locations:\n")
            // for location in locations { print("[displayOrder: \(location.displayOrder), name: \(location.name), lat: \(location.latitude), lon:\(location.longitude), country: \(location.country), state: \(location.state)]") }
        } catch {
            print("Could not load locations")
        }
    }
}

#if DEBUG
extension CoreDataManager {
    func loadTestData() {
        while locations.isEmpty == false {
            deleteLocationAt(0)
        }
        saveContext()
        
        addLocation(displayOrder: 0, name: "London", latitude: 51.4875167, longitude: -0.1687007, country: "GB", state: "England")
        addLocation(displayOrder: 1, name: "Chicago", latitude: 41.8755616, longitude: -87.6244212, country: "US", state: "Illinois")
        addLocation(displayOrder: 2, name: "Rome", latitude: 41.8933203, longitude: 12.4829321, country: "IT", state: "Lazio")
        addLocation(displayOrder: 3, name: "Tokyo", latitude: 35.709674, longitude: 139.454224, country: "JP", state: "")
        addLocation(displayOrder: 4, name: "Honolulu", latitude: 21.316, longitude: -157.801, country: "US", state: "Hawaii")
        saveContext()
        loadData()
    }
}
#endif
