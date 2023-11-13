//
//  FullForecastOverlayView.swift
//  Weather
//
//  Created by jonathan saville on 13/11/2023.
//

import SwiftUI

struct FullForecastOverlayView: View {

    static let topSpacerHeight: CGFloat = 12
    static let feedbackViewHeight: CGFloat = 76
    static let bottomSpacerHeight: CGFloat = 12
    static let bottomTitleHeight: CGFloat = 36
    static let height: CGFloat = topSpacerHeight + feedbackViewHeight + bottomSpacerHeight + bottomTitleHeight

    var body: some View {

        VStack(spacing: 0) {
     
            Rectangle()
                .foregroundColor(Color(UIColor.backgroundPrimary()))
                .clipShape(.rect( bottomLeadingRadius: defaultCornerRadius, bottomTrailingRadius: defaultCornerRadius))
                .frame(height: Self.topSpacerHeight)
         
            HStack() {
                Text("How accurate do you find the forecast?")
                 .padding(8)
                Spacer()
                Image(systemName: "chevron.down")
            }
            .foregroundColor(Color(.button(for: .highlighted)))
            .padding(8)
            .background(Color(UIColor.backgroundPrimary()))
            .cornerRadius(defaultCornerRadius)
            .frame(height: Self.feedbackViewHeight)
         
            Rectangle()
                .foregroundColor(Color(UIColor.backgroundPrimary()))
                .clipShape(.rect( topLeadingRadius: defaultCornerRadius, topTrailingRadius: defaultCornerRadius))
                .frame(height: Self.bottomSpacerHeight)

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
