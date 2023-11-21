//
//  WarningsView.swift
//  Weather
//
//  Created by jonathan saville on 06/10/2023.
//

import SwiftUI

struct WarningsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {

        NavigationStack() {
            ZStack {
                Color.black.ignoresSafeArea()
                Text(AlertMessage.notYetImplemented)
                    .foregroundColor(Color(.button(for: .highlighted)))
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Warnings")
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}

struct WarningsView_Previews: PreviewProvider {
    static var previews: some View {
        WarningsView()
            .preferredColorScheme(.dark)
    }
}
