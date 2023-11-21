//
//  RemoveAdsView.swift
//  Weather
//
//  Created by jonathan saville on 26/09/2023.
//

import SwiftUI

struct RemoveAdsView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text(AlertMessage.notYetImplemented)
                .foregroundColor(Color(.button(for: .highlighted)))
        }
        .navigationTitle("Advertising")
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

struct RemoveAdsView_Previews: PreviewProvider {
    static var previews: some View {
        RemoveAdsView()
            .preferredColorScheme(.dark)
    }
}
