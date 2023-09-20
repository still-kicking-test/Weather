//
//  Location+Ext.swift
//  Weather
//
//  Created by jonathan saville on 19/09/2023.
//

import Foundation

/// wrapper functionality  to convert from Swift types to CoreData (objc) types
extension Location {
    
    func setDisplayOrder(_ value: Int) {
        displayOrder = Int16(value)
    }
    
    var coordinates: Coordinates { (latitude as Decimal, longitude as Decimal) }
 }
