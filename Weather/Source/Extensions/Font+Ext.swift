//
//  Font+Ext.swift
//  Weather
//
//  Created by jonathan saville on 10/10/2023.
//

import SwiftUI

public extension Font {
    static var defaultSize: CGFloat { 15 }
    
    static let defaultFont: Font = .system(size: defaultSize)
    static let defaultFontBold: Font = .system(size: defaultSize, weight: .bold)
    static let largeFont: Font = .system(size: 18)
    static let largeFontBold: Font = .system(size: 18, weight: .bold)
    static let veryLargeFont: Font = .system(size: 24)
    static let veryLargeFontBold: Font = .system(size: 24, weight: .bold)
    
    static let defaultFontLineHeight: CGFloat = UIFont.systemFont(ofSize: defaultSize).lineHeight // note - no way to convert Font to UIFont
}
