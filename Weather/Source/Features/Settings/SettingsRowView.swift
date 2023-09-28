//
//  SettingsRowView.swift
//  Weather
//
//  Created by jonathan saville on 26/09/2023.
//

import SwiftUI

struct SettingsRowView: View {
    var row: SettingsRow
    
    var body: some View {
        HStack {
            if let imageName = row.imageName {
                Image(systemName: imageName)
            }
            Text(row.description)
        }
    }
}

struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(row: .notifications)
    }
}
