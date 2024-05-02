//
//  CDLocation+CoreDataProperties.swift
//  Weather
//
//  Created by jonathan saville on 03/10/2023.
//
//

import Foundation
import CoreData


extension CDLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDLocation> {
        return NSFetchRequest<CDLocation>(entityName: "CDLocation")
    }

    @NSManaged public var country: String
    @NSManaged public var displayOrder: Int16
    @NSManaged public var latitude: NSDecimalNumber
    @NSManaged public var longitude: NSDecimalNumber
    @NSManaged public var name: String
    @NSManaged public var state: String
    @NSManaged public var uuid: UUID
}

extension CDLocation : Identifiable {

}
