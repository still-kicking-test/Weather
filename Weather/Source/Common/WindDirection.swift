//
//  WindDirection.swift
//  Weather
//
//  Created by jonathan saville on 04/09/2023.
//

import Foundation

enum WindDirection: String {
    case North = "N"
    case NorthNorthEast = "NNE"
    case NorthEast = "NE"
    case EastNorthEast = "ENE"
    case East = "E"
    case EastSouthEast = "ESE"
    case SouthEast = "SE"
    case SouthSouthEast = "SSE"
    case South = "S"
    case SouthSouthWest = "SSW"
    case SouthWest = "SW"
    case WestSouthWest = "WSW"
    case West = "W"
    case WestNorthWest = "WNW"
    case NorthWest = "NW"
    case NorthNorthWest = "NNW"

    static func fromDegrees(_ degrees: Int) -> WindDirection {
        let cardinals: [WindDirection] = [.North,
                                          .NorthNorthEast,
                                          .NorthEast,
                                          .EastNorthEast,
                                          .East,
                                          .EastSouthEast,
                                          .SouthEast,
                                          .SouthSouthEast,
                                          .South,
                                          .SouthSouthWest,
                                          .SouthWest,
                                          .WestSouthWest,
                                          .West,
                                          .WestNorthWest,
                                          .NorthWest,
                                          .NorthNorthWest,
                                          .North ]
        
        let index = Int(round(Double(degrees).truncatingRemainder(dividingBy: 360) / 22.5))
        return cardinals[index]
    }
}
