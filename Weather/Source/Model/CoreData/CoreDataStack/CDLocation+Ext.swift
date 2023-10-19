//
//  CDLocation+Ext.swift
//  Weather
//
//  Created by jonathan saville on 19/09/2023.
//

import Foundation

/// CoreData wrapper functionality
extension CDLocation {
    
    func setDisplayOrder(_ value: Int) {
        displayOrder = Int16(value)
    }
 }
