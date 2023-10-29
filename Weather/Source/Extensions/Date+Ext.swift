//
//  Date+Ext.swift
//  Weather
//
//  Created by jonathan saville on 07/09/2023.
//

import Foundation

extension Date {
    
    func shortDayOfWeek(_ secondsFromGMT: Int) -> String? {
        guard let timezone = TimeZone(secondsFromGMT: secondsFromGMT) else { return nil }
        var calendar = Calendar.current
        calendar.timeZone = timezone
        guard calendar.isDateInToday(self) == false else { return "Today" }
    
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timezone
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self).capitalized
    }
    
    func formattedTime(_ secondsFromGMT: Int) -> String? {
        guard let timezone = TimeZone(secondsFromGMT: secondsFromGMT) else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timezone
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func daysInFuture(_ days: Int) -> Date {
        addingTimeInterval(Double(days * 86400))
    }
    
    var nextDay: Date {
        daysInFuture(1)
    }
}
