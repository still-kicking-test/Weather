//
//  PrimaryButtonStyle.swift
//  Weather
//
//  Created by jonathan saville on 28/09/2023.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    
    var stateColour: UIControl.State = .highlighted
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color(UIColor.button(for: stateColour)))
    }
}
