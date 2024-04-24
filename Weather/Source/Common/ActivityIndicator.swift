//
//  ActivityIndicator.swift
//  Weather
//
//  Created by jonathan saville on 14/03/2024.
//

import SwiftUI

struct ActivityIndicator: View {

    private let color: SwiftUI.Color

    @State private var trimAnimation = false
    @State private var rotationAnimation = false
    @State private var isAnimating = false
    private let baseAnimation: Animation = .linear(duration: 1)

    init(color: SwiftUI.Color = .white) {
        self.color = color
    }

    var body: some View {
        Circle()
            .trim(from: 0, to: rotationAnimation ? 0 : 0.75)
            .stroke(color,
                    lineWidth: 2)
            .rotationEffect(.degrees(trimAnimation ? 0 : -360))
            .onAppear {
                if !isAnimating {
                    isAnimating = true
                    withAnimation(baseAnimation.repeatForever(autoreverses: false)) {
                        trimAnimation.toggle()
                    }

                    withAnimation(baseAnimation.repeatForever(autoreverses: true)) {
                        rotationAnimation.toggle()
                    }
                }
            }
            .background(.clear)
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator()
    }
}
