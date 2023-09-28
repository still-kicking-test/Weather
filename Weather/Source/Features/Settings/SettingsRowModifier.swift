//
//  SettingsRowModifier.swift
//  Weather
//
//  Created by jonathan saville on 28/09/2023.
//

import SwiftUI

struct SettingsRowModifier: ViewModifier {
    let font: Font?
    let separatorTint: Color
    let foregroundColor: Color
    
    init(font: Font?,
         separatorTint: Color,
         foregroundColor: Color?) {
        self.font = font
        self.separatorTint = separatorTint
        self.foregroundColor = foregroundColor ?? (Color(UIColor.defaultText()))
    }
    
    func body(content: Content) -> some View {
        content
            .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in 0 }
            .listRowSeparatorTint(separatorTint)
            .listRowBackground(Color.clear)
            .foregroundColor(foregroundColor)
            .font(font)
    }
}

extension View {
    func settingsRowModifier(font: Font? = nil,
                             separatorTint: Color = .white,
                             foregroundColor: Color? = nil) -> some View {

        modifier(SettingsRowModifier(font: font,
                                     separatorTint: separatorTint,
                                     foregroundColor: foregroundColor))
    }
}
