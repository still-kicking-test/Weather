//
//  CustomizeView.swift
//  Weather
//
//  Created by jonathan saville on 26/09/2023.
//

import SwiftUI

struct CustomizeView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text(AlertMessage.notYetImplemented)
                .foregroundColor(Color(.button(for: .highlighted)))
        }
        .navigationTitle("Customise your view")
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

struct CustomizeView_Previews: PreviewProvider {
    @State static private var path = NavigationPath()
    static var previews: some View {
        CustomizeView()
            .preferredColorScheme(.dark)
    }
}
