//
//  WarningsView.swift
//  Weather
//
//  Created by jonathan saville on 06/10/2023.
//

import SwiftUI

struct WarningsView: View {
    
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
                    Text("Weather warnings").font(.largeFont)
                        .foregroundColor(.defaultText)
                }
            }
        }
    }
}

struct WarningsView_Previews: PreviewProvider {
    static var previews: some View {
        WarningsView()
            .preferredColorScheme(.dark)
    }
}
