//
//  UIColor+Ext.swift
//  Weather
//
//  Created by jonathan saville on 01/09/2023.
//

import UIKit

public extension UIColor {
    
    static var forceMode: UIUserInterfaceStyle = .dark // very quick and dirty DEV-ONLY way to force darkmode until I have implemented sensible light colours

    private enum Colours {
        enum dark {
            static let defaultText = UIColor.white
            static let backgroundPrimary = UIColor.black
            static let backgroundSecondary = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
            static let divider = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
            static let backgroundGradientFrom = backgroundSecondary
            static let backgroundGradientTo = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            static let navbarBackground = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            static let buttonNormal = UIColor.gray
            static let buttonDisabled = UIColor.lightGray
            static let buttonHighlighted = UIColor(red: 0.8, green: 1, blue: 0.2, alpha:1)
            static let windAndRain = UIColor(red: 0.3, green: 0.7, blue: 0.97, alpha:1)
       }
        enum light {
            static let defaultText = UIColor.black
            static let backgroundPrimary = UIColor.white
            static let backgroundSecondary = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            static let divider = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            static let backgroundGradientFrom = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
            static let backgroundGradientTo = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
            static let navbarBackground = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
            static let buttonNormal = UIColor.gray
            static let buttonDisabled = UIColor.lightGray
            static let buttonHighlighted = UIColor(red: 0, green: 0.5, blue: 0, alpha: 1)
            static let windAndRain = UIColor(red: 0.3, green: 0.7, blue: 0.97, alpha:1)
        }
    }
    
    static func defaultText() -> UIColor {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            UITraitCollection.userInterfaceStyle == .dark || forceMode == .dark ? Colours.dark.defaultText : Colours.light.defaultText
        }
    }

    static func button(for state: UIControl.State) -> UIColor {
        switch state {
        case .disabled:
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                UITraitCollection.userInterfaceStyle == .dark || forceMode == .dark ? Colours.dark.buttonDisabled : Colours.light.buttonDisabled }
        case .highlighted, .selected:
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                UITraitCollection.userInterfaceStyle == .dark || forceMode == .dark ? Colours.dark.buttonHighlighted : Colours.light.buttonHighlighted }
        default:
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                UITraitCollection.userInterfaceStyle == .dark || forceMode == .dark ? Colours.dark.buttonNormal : Colours.light.buttonNormal }
        }
    }

    static func navbarBackground() -> UIColor {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            UITraitCollection.userInterfaceStyle == .dark || forceMode == .dark ? Colours.dark.navbarBackground : Colours.light.navbarBackground
        }
    }

    static func backgroundPrimary() -> UIColor {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            UITraitCollection.userInterfaceStyle == .dark || forceMode == .dark ? Colours.dark.backgroundPrimary : Colours.light.backgroundPrimary
        }
    }

    static func backgroundGradientFrom() -> UIColor {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            UITraitCollection.userInterfaceStyle == .dark || forceMode == .dark ? Colours.dark.backgroundGradientFrom : Colours.light.backgroundGradientFrom
        }
    }

    static func backgroundGradientTo() -> UIColor {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            UITraitCollection.userInterfaceStyle == .dark || forceMode == .dark ? Colours.dark.backgroundGradientTo : Colours.light.backgroundGradientTo
        }
    }

    static func backgroundSecondary(alpha: CGFloat = 1.0) -> UIColor {
        let color = UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            UITraitCollection.userInterfaceStyle == .dark || forceMode == .dark ? Colours.dark.backgroundSecondary : Colours.light.backgroundSecondary
        }
        return color.withAlphaComponent(alpha)
    }
    
    static func divider() -> UIColor {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            UITraitCollection.userInterfaceStyle == .dark || forceMode == .dark ? Colours.dark.divider : Colours.light.divider
        }
    }
    
    static func windAndRain() -> UIColor {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            UITraitCollection.userInterfaceStyle == .dark || forceMode == .dark ? Colours.dark.windAndRain : Colours.light.windAndRain
        }
    }
    
    static func colour(forDegreesCelsius degreesCelsius: Decimal?) -> UIColor {

        func mapValue(value: CGFloat, inMin: CGFloat, inMax: CGFloat, outMin: CGFloat, outMax: CGFloat) -> CGFloat {
            let value = max(min(value, inMax), inMin)
            let div = inMax - inMin
            guard div > 0 else { return inMin }

            return (value - inMin) / div * (outMax - outMin) + outMin
        }

        guard let degreesCelsius = degreesCelsius else { return .clear }

        lazy var colourImage = UIImage(named: "temperatureColourScale.png")!
        let imageSize = colourImage.size
        let inMin: CGFloat = -30
        let inMax: CGFloat = 40

        let mappedInput = mapValue(value: CGFloat(NSDecimalNumber(decimal: degreesCelsius).floatValue),
                                   inMin: inMin, inMax: inMax,
                                   outMin: 0, outMax: imageSize.width - 1)

        let pixelPosition = CGPoint(x: mappedInput, y: 0)

        return colourImage.getPixelColor(position: pixelPosition)
    }

    static func colour(forPrecipitation precipitation: Decimal?) -> UIColor {
        precipitation ?? 0 >= 0.5 ? .windAndRain() : .defaultText()
    }
}
