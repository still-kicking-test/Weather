//
//  CoreDataManager+Stubs.swift
//  Weather
//
//  Created by jonathan saville on 26/03/2024.
//

import Foundation

extension CoreDataManager {

    class Stub: CoreDataManagerProtocol {
        func saveContext() {}
        func deleteLocationAt(_ row: Int) {}
        func addLocation(displayOrder: Int,
                         name: String,
                         latitude: Decimal,
                         longitude: Decimal,
                         country: String,
                         state: String) {}
        func loadTestData() {}
    }
    
    public static var stub: CoreDataManagerProtocol {
        CoreDataManager.Stub()
    }
}
