//
//  Date+Ext.swift
//  Weather
//
//  Created by jonathan saville on 07/09/2023.
//

import Foundation

extension Date {
    
    var shortDayOfWeek: String {
        guard Calendar.current.isDateInToday(self) == false else { return "Today" }
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self).capitalized
    }
    
    var formattedTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: self)
    }
}
