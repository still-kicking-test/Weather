//
//  Color+Ext.swift
//  Weather
//
//  Created by jonathan saville on 01/09/2023.
//

import SwiftUI

public extension Color {
    
    private enum Colours {
        enum dark {
            static let defaultText = Color.white
            static let backgroundPrimary = Color.black
            static let backgroundSecondary = Color(red: 0.15, green: 0.15, blue: 0.15)
            static let divider = Color(red: 0.5, green: 0.5, blue: 0.5)
            static let backgroundGradientFrom = Color(red: 0.6, green: 0.6, blue: 0.6)
            static let backgroundGradientTo = navbarBackground
            static let navbarBackground = Color(red: 0.2, green: 0.2, blue: 0.2)
            static let windAndRain = Color(red: 0.3, green: 0.7, blue: 0.97)
       }
        enum light {
            static let defaultText = Color.black
            static let backgroundPrimary = Color.white
            static let backgroundSecondary = Color(red: 0.8, green: 0.8, blue: 0.8)
            static let divider = Color(red: 0.95, green: 0.95, blue: 0.95)
            static let backgroundGradientFrom = Color(red: 0.9, green: 0.9, blue: 0.9)
            static let backgroundGradientTo = navbarBackground
            static let navbarBackground = Color(red: 0.9, green: 0.9, blue: 0.9)
            static let windAndRain = Color(red: 0.3, green: 0.7, blue: 0.97)
        }
    }
    
    static var defaultText: Color {
        dynamicColor(darkColor: Colours.dark.defaultText, lightColor: Colours.light.defaultText)
    }

    static var navbarBackground: Color {
        dynamicColor(darkColor: Colours.dark.navbarBackground, lightColor: Colours.light.navbarBackground)
    }

    static var backgroundPrimary: Color {
        dynamicColor(darkColor: Colours.dark.backgroundPrimary, lightColor: Colours.light.backgroundPrimary)
    }

    static var backgroundGradientFrom: Color {
        dynamicColor(darkColor: Colours.dark.backgroundGradientFrom, lightColor: Colours.light.backgroundGradientFrom)
    }

    static var backgroundGradientTo: Color {
        dynamicColor(darkColor: Colours.dark.backgroundGradientTo, lightColor: Colours.light.backgroundGradientTo)
    }

    static var backgroundSecondary: Color {
        dynamicColor(darkColor: Colours.dark.backgroundSecondary, lightColor: Colours.light.backgroundSecondary)
    }
    
    static var divider: Color {
        dynamicColor(darkColor: Colours.dark.divider, lightColor: Colours.light.divider)
    }
    
    static var windAndRain: Color {
        dynamicColor(darkColor: Colours.dark.windAndRain, lightColor: Colours.light.windAndRain)
    }
    
    static func colour(forDegreesCelsius degreesCelsius: Decimal?) -> Color {

        func mapValue(value: CGFloat, inMin: CGFloat, inMax: CGFloat, outMin: CGFloat, outMax: CGFloat) -> CGFloat {
            let value = max(min(value, inMax), inMin)
            let div = inMax - inMin
            guard div > 0 else { return inMin }

            return (value - inMin) / div * (outMax - outMin) + outMin
        }

        guard let degreesCelsius = degreesCelsius else { return .clear }

        lazy var colourScaleImage = UIImage(named: "temperatureColourScale.png")!
        let imageSize = colourScaleImage.size
        let inMin: CGFloat = -30
        let inMax: CGFloat = 40

        let mappedInput = mapValue(value: CGFloat(NSDecimalNumber(decimal: degreesCelsius).floatValue),
                                   inMin: inMin, inMax: inMax,
                                   outMin: 0, outMax: imageSize.width - 1)

        let pixelPosition = CGPoint(x: mappedInput, y: 0)

        return colourScaleImage.getPixelColor(position: pixelPosition)
    }

    static func colour(forPrecipitation precipitation: Decimal?) -> Color {
        precipitation ?? 0 >= 0.5 ? .windAndRain : .defaultText
    }
    
    private static func dynamicColor(darkColor: Color, lightColor: Color) -> Color {
        let forceMode: UIUserInterfaceStyle = .dark // very quick and dirty DEV-ONLY way to force darkmode until I have implemented sensible light colours

        let uiColor = UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            UITraitCollection.userInterfaceStyle == .dark || forceMode == .dark ? UIColor(darkColor) : UIColor(lightColor) }
        return Color(uiColor)
    }
}
