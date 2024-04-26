//
//  Font+Ext.swift
//  Weather
//
//  Created by jonathan saville on 10/10/2023.
//

import SwiftUI

public extension Font {
    static var defaultSize: CGFloat { 15 }
    static var largeSize: CGFloat { 18 }
    static var veryLargeSize: CGFloat { 24 }

    static let defaultFont: Font = .system(size: defaultSize)
    static let defaultFontBold: Font = .system(size: defaultSize, weight: .bold)
    static let largeFont: Font = .system(size: largeSize)
    static let largeFontBold: Font = .system(size: largeSize, weight: .bold)
    static let veryLargeFont: Font = .system(size: veryLargeSize)
    static let veryLargeFontBold: Font = .system(size: veryLargeSize, weight: .bold)
    
    // note - no way to convert Font to UIFont, so define the lineHieghts statically...
    static let defaultFontLineHeight: CGFloat = UIFont.systemFont(ofSize: defaultSize).lineHeight
    static let largeFontLineHeight: CGFloat = UIFont.systemFont(ofSize: largeSize).lineHeight
}
