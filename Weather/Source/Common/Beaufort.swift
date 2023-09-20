//
//  Beaufort.swift
//  Weather
//
//  Created by jonathan saville on 04/09/2023.
//
import Foundation

enum Beaufort: String {
    case Calm = "Calm"
    case LightAir = "Light Air"
    case LightBreeze = "Light Breeze"
    case GentleBreeze = "Gentle Breeze"
    case ModerateBreeze = "Moderate Breeze"
    case FreshBreeze = "Fresh Breeze"
    case StrongBreeze = "Strong Breeze"
    case NearGale = "Near Gale"
    case Gale = "Gale"
    case StrongGale = "Strong Gale"
    case Storm = "Storm"
    case ViolentStorm = "Violent Storm"
    case Hurricane = "Hurricane"
    
    static func fromSpeed(_ speed: Decimal) -> Beaufort {
        switch speed {
        case _ where speed <  1: return Beaufort.Calm
        case _ where speed <  2: return Beaufort.LightAir
        case _ where speed <  3: return Beaufort.LightBreeze
        case _ where speed <  5: return Beaufort.GentleBreeze
        case _ where speed <  8: return Beaufort.ModerateBreeze
        case _ where speed < 11: return Beaufort.FreshBreeze
        case _ where speed < 14: return Beaufort.StrongBreeze
        case _ where speed < 17: return Beaufort.NearGale
        case _ where speed < 21: return Beaufort.Gale
        case _ where speed < 24: return Beaufort.StrongGale
        case _ where speed < 28: return Beaufort.Storm
        case _ where speed < 32: return Beaufort.ViolentStorm
        default: return Beaufort.Hurricane
        }
    }
}
