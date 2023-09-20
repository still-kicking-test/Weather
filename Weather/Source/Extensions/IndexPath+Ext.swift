//
//  IndexPath+Ext.swift
//  Weather
//
//  Created by jonathan saville on 12/09/2023.
//

import Foundation

extension IndexPath {

    var previousRow: IndexPath? {
        previousRow(step: 1)
    }
    
    func previousRow(step: Int) -> IndexPath? {
        guard row - step >= 0 else { return nil }
        return IndexPath(row: row - step, section: self.section)
    }
    
    var nextRow: IndexPath {
        IndexPath(row: row + 1, section: self.section)
    }
}
