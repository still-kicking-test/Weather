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
        Button {
          dismiss()
        } label: {
          Text("Close")
        }
        Text("Settings - TBD")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
