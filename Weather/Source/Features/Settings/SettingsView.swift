//
//  SettingsView.swift
//  Weather
//
//  Created by jonathan saville on 13/09/2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Spacer()
                Button("Done", role: .cancel) {
                    dismiss()
                }
                .buttonStyle(PlainButtonStyle(stateColour: .highlighted))
            }
            Spacer()
        }
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct PlainButtonStyle: ButtonStyle {
    var stateColour: UIControl.State = .highlighted
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color(UIColor.button(for: stateColour)))
    }
}
