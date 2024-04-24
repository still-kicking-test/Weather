//
//  MapsView.swift
//  Weather
//
//  Created by jonathan saville on 06/10/2023.
//

import SwiftUI

struct MapsView: View {
    
    var body: some View {

        NavigationStack() {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.backgroundGradientFrom,
                                                           .backgroundGradientTo]), startPoint: .bottom, endPoint: .top)
                Text(CommonStrings.notYetImplemented)
                    .foregroundColor(.defaultText)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.navbarBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Maps").font(.largeFont)
                        .foregroundColor(.defaultText)
                }
            }
        }
    }
}

struct MapsView_Previews: PreviewProvider {
    static var previews: some View {
        MapsView()
            .preferredColorScheme(.dark)
    }
}
