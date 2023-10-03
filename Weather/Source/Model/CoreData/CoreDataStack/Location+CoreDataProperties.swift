//
//  Location+CoreDataProperties.swift
//  Weather
//
//  Created by jonathan saville on 19/09/2023.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var country: String
    @NSManaged public var displayOrder: Int16
    @NSManaged public var latitude: NSDecimalNumber
    @NSManaged public var longitude: NSDecimalNumber
    @NSManaged public var name: String
    @NSManaged public var state: String

}

extension Location : Identifiable {

}
