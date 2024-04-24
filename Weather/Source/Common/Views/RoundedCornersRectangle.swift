//
//  RoundedCornersRectangle.swift
//  Weather
//
//  Created by jonathan saville on 14/11/2023.
//

import SwiftUI

enum RoundedCorners: Equatable {
    case top(radius: CGFloat = Self.defaultRadius)
    case bottom(radius: CGFloat = Self.defaultRadius)
    case both(radius: CGFloat = Self.defaultRadius)
    
    static let defaultRadius: CGFloat = 12
    
    var topRadius: CGFloat { switch self { case .top(let radius), .both(let radius): radius; default: 0 } }
    var bottomRadius: CGFloat { switch self { case .bottom(let radius), .both(let radius): radius; default: 0 } }
}

struct RoundedCornersRectangle: View {

    private let corners: RoundedCorners
    private let height: CGFloat
    private let color: Color
    
    init(roundedCorners corners: RoundedCorners,
         height: CGFloat = RoundedCorners.defaultRadius,
         color: Color = .backgroundPrimary) {
        self.corners = corners
        self.height = height
        self.color = color
     }

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: height)
            .clipShape(.rect( topLeadingRadius: corners.topRadius,
                              bottomLeadingRadius: corners.bottomRadius,
                              bottomTrailingRadius: corners.bottomRadius,
                              topTrailingRadius: corners.topRadius))
    }
}

#Preview {
    RoundedCornersRectangle(roundedCorners: .bottom())
}
