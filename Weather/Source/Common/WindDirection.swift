//
//  WindDirection.swift
//  Weather
//
//  Created by jonathan saville on 04/09/2023.
//

import Foundation

enum WindDirection: String {
    case North      = "N"
    case NorthEast  = "NE"
    case East       = "E"
    case SouthEast  = "SE"
    case South      = "S"
    case SouthWest  = "SW"
    case West       = "W"
    case NorthWest  = "NW"
    
    static func fromDegrees(_ degrees: Int) -> WindDirection {
        let cardinals: [WindDirection] = [.North,
                                          .NorthEast,
                                          .East,
                                          .SouthEast,
                                          .South,
                                          .SouthWest,
                                          .West,
                                          .NorthWest,
                                          .North ]
        
        let index = Int(round(Double(degrees).truncatingRemainder(dividingBy: 360) / 45))
        return cardinals[index]
    }
}
