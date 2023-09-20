//
//  Int.swift
//  Weather
//
//  Created by jonathan saville on 07/09/2023.
//

extension Int {
    
    var windDirection: WindDirection { WindDirection.fromDegrees(self) }
}
