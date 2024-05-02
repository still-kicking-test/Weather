//
//  View+Ext.swift
//  Weather
//
//  Created by jonathan saville on 30/04/2024.
//

import SwiftUI

public extension View {
    func displayAsCard() -> some View {
        self.modifier( CardDisplayModifier() )
     }
}

private struct CardDisplayModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.backgroundPrimary)
            .foregroundColor(.defaultText)
            .cornerRadius(RoundedCorners.defaultRadius)
            .padding([.leading, .trailing], 8)
    }
}

