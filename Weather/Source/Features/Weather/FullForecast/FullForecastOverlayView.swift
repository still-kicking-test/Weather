//
//  FullForecastOverlayView.swift
//  Weather
//
//  Created by jonathan saville on 13/11/2023.
//

import SwiftUI

struct FullForecastOverlayView: View {

    static let height: CGFloat = topViewHeight + feedbackViewHeight + bottomViewHeight
    
    @Binding var isScrollLeftButtonEnabled: Bool
    @Binding var isScrollRightButtonEnabled: Bool
    var scrollLeftButtonTapped: () -> Void
    var scrollRightButtonTapped: () -> Void
    
    private static let topViewHeight: CGFloat = 48
    private static let feedbackViewHeight: CGFloat = 76
    private static let bottomViewHeight: CGFloat = 44

    var body: some View {

        VStack(spacing: 0) {

            // topView
            HStack() {
                Spacer()
                HStack(spacing: 16) {
                    Button(action: { scrollLeftButtonTapped() }) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(isScrollLeftButtonEnabled ? Color(.button(for: .highlighted)) : Color(.divider()))
                    }
                    .disabled(!isScrollLeftButtonEnabled)
                    
                    Rectangle()
                        .fill(Color(.divider()))
                        .frame(width: 1)

                    Button(action: { scrollRightButtonTapped() }) {
                        Image(systemName: "chevron.forward")
                            .foregroundColor(isScrollRightButtonEnabled ? Color(.button(for: .highlighted)) : Color(.divider()))
                    }
                    .disabled(!isScrollRightButtonEnabled)
               }
                .frame(height: 32)
                .padding([.trailing], 24)
            }
            .padding([.top, .bottom], 8)
            .background(Color(UIColor.backgroundPrimary()))
            .clipShape(.rect( bottomLeadingRadius: RoundedCorners.defaultRadius,
                              bottomTrailingRadius: RoundedCorners.defaultRadius))
            .frame(height: Self.topViewHeight)

            // feedbackView
            HStack() {
                Text("How accurate do you find the forecast?")
                 .padding(8)
                Spacer()
                Image(systemName: "chevron.down")
            }
            .padding(8)
            .background(Color(UIColor.backgroundPrimary()))
            .foregroundColor(Color(.button(for: .highlighted)))
            .cornerRadius(RoundedCorners.defaultRadius)
            .frame(height: Self.feedbackViewHeight)

            // bottomView
            HStack() {
                Text("Wind Forecast")
                    .font(Font(UIFont.largeFontBold))
                Spacer()
                Image(systemName: "info.circle.fill")
                    .foregroundColor(Color(.button(for: .highlighted)))
            }
            .padding([.leading, .trailing], 8)
            .padding([.top, .bottom], 12)
            .background(Color(UIColor.backgroundPrimary()))
            .clipShape(.rect( topLeadingRadius: RoundedCorners.defaultRadius,
                              topTrailingRadius: RoundedCorners.defaultRadius))
            .frame(height: Self.bottomViewHeight)
       }
    }
}

struct FullforecastOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        TwoStatesPreviewWrapper(false, true) { FullForecastOverlayView(isScrollLeftButtonEnabled: $0,
                                                                       isScrollRightButtonEnabled: $1,
                                                                       scrollLeftButtonTapped: {},
                                                                       scrollRightButtonTapped: {}) }
        .background(.gray)
        .preferredColorScheme(.dark)
    }
}
