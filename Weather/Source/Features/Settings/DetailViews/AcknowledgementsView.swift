//
//  AcknowledgementsView.swift
//  Weather
//
//  Created by jonathan saville on 26/09/2023.
//

import SwiftUI

struct AcknowledgementsView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text(AlertMessage.notYetImplemented)
                .foregroundColor(Color(.button(for: .highlighted)))
        }
        .navigationTitle("Acknowledgements")
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

struct AcknowledgementsView_Previews: PreviewProvider {
    static var previews: some View {
        AcknowledgementsView()
            .preferredColorScheme(.dark)
    }
}
