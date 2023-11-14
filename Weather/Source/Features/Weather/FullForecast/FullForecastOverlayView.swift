//
//  FullForecastOverlayView.swift
//  Weather
//
//  Created by jonathan saville on 13/11/2023.
//

import SwiftUI

struct FullForecastOverlayView: View {

    static let height: CGFloat = roundedTopCornerRadius + feedbackViewHeight + roundedBottomCornerRadius + bottomTitleHeight
    
    private static let roundedTopCornerRadius: CGFloat = RoundedCorners.defaultRadius
    private static let feedbackViewHeight: CGFloat = 76
    private static let roundedBottomCornerRadius: CGFloat = RoundedCorners.defaultRadius
    private static let bottomTitleHeight: CGFloat = 36

    var body: some View {

        VStack(spacing: 0) {

            RoundedCornersRectangle(roundedCorners: .bottom(), height: Self.roundedTopCornerRadius)

            HStack() {
                Text("How accurate do you find the forecast?")
                 .padding(8)
                Spacer()
                Image(systemName: "chevron.down")
            }
            .foregroundColor(Color(.button(for: .highlighted)))
            .padding(8)
            .background(Color(UIColor.backgroundPrimary()))
            .cornerRadius(RoundedCorners.defaultRadius)
            .frame(height: Self.feedbackViewHeight)

            RoundedCornersRectangle(roundedCorners: .top(), height: Self.roundedBottomCornerRadius)

            HStack() {
                Text("Wind Forecast")
                    .font(Font(UIFont.largeFontBold))
                Spacer()
                Image(systemName: "info.circle.fill")
                    .foregroundColor(Color(.button(for: .highlighted)))
            }
            .padding(8)
            .padding([.bottom], 12)
            .frame(height: Self.bottomTitleHeight)
            .background(Color(UIColor.backgroundPrimary()))
        }
    }
}

#Preview {
    FullForecastOverlayView()
        .preferredColorScheme(.dark)
        .frame(height: FullForecastOverlayView.height)
        .background(.gray)
}
