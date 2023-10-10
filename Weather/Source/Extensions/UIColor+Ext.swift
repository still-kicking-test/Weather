//
//  UIColor+Ext.swift
//  Weather
//
//  Created by jonathan saville on 01/09/2023.
//

import UIKit

extension UIColor {
    
    private enum Colours {
        enum dark {
            static let defaultText = UIColor.white
            static let backgroundPrimary = UIColor.black
            static let backgroundSecondary = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
            static let backgroundTertiary = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
            static let backgroundGradientFrom = backgroundSecondary
            static let backgroundGradientTo = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            static let navbarBackground = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            static let buttonNormal = UIColor.gray
            static let buttonDisabled = UIColor.lightGray
            static let buttonHighlighted = UIColor(red: 0.8, green: 1, blue: 0.2, alpha:1)
       }
        enum light {
            static let defaultText = UIColor.black
            static let backgroundPrimary = UIColor.white
            static let backgroundSecondary = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            static let backgroundTertiary = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            static let backgroundGradientFrom = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
            static let backgroundGradientTo = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
            static let navbarBackground = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
            static let buttonNormal = UIColor.gray
            static let buttonDisabled = UIColor.lightGray
            static let buttonHighlighted = UIColor(red: 0, green: 0.5, blue: 0, alpha: 1)
        }
    }
    
    static func defaultText() -> UIColor {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            UITraitCollection.userInterfaceStyle == .dark ? Colours.dark.defaultText : Colours.light.defaultText
        }
    }

    static func button(for state: UIControl.State) -> UIColor {
        switch state {
        case .disabled:
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                UITraitCollection.userInterfaceStyle == .dark ? Colours.dark.buttonDisabled : Colours.light.buttonDisabled }
        case .highlighted, .selected:
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                UITraitCollection.userInterfaceStyle == .dark ? Colours.dark.buttonHighlighted : Colours.light.buttonHighlighted }
        default:
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                UITraitCollection.userInterfaceStyle == .dark ? Colours.dark.buttonNormal : Colours.light.buttonNormal }
        }
    }

    static func navbarBackground() -> UIColor {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            UITraitCollection.userInterfaceStyle == .dark ? Colours.dark.navbarBackground : Colours.light.navbarBackground
        }
    }

    static func backgroundPrimary() -> UIColor {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            UITraitCollection.userInterfaceStyle == .dark ? Colours.dark.backgroundPrimary : Colours.light.backgroundPrimary
        }
    }

    static func backgroundGradientFrom() -> UIColor {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            UITraitCollection.userInterfaceStyle == .dark ? Colours.dark.backgroundGradientFrom : Colours.light.backgroundGradientFrom
        }
    }

    static func backgroundGradientTo() -> UIColor {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            UITraitCollection.userInterfaceStyle == .dark ? Colours.dark.backgroundGradientTo : Colours.light.backgroundGradientTo
        }
    }

    static func backgroundSecondary(alpha: CGFloat = 1.0) -> UIColor {
        let color = UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            UITraitCollection.userInterfaceStyle == .dark ? Colours.dark.backgroundSecondary : Colours.light.backgroundSecondary
        }
        return color.withAlphaComponent(alpha)
    }
    
    static func backgroundTertiary() -> UIColor {
        UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            UITraitCollection.userInterfaceStyle == .dark ? Colours.dark.backgroundTertiary : Colours.light.backgroundTertiary
        }
    }
}
