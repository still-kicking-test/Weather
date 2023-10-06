//
//  MapsView.swift
//  Weather
//
//  Created by jonathan saville on 06/10/2023.
//

import SwiftUI

struct MapsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {

        NavigationStack() {
            ZStack {
                Color.black.ignoresSafeArea()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Maps")
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}

struct MapsView_Previews: PreviewProvider {
    static var previews: some View {
        MapsView()
            .preferredColorScheme(.dark)
    }
}
