//
//  FullForecastOverlayView.swift
//  Weather
//
//  Created by jonathan saville on 13/11/2023.
//

import SwiftUI

struct FullForecastOverlayView: View {

    static let height: CGFloat = topViewHeight + feedbackViewHeight + bottomViewHeight
    
    @State private var shouldShowNotImplemented: Bool = false

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
            ScrollButtonsView (isScrollLeftButtonEnabled: $isScrollLeftButtonEnabled,
                               isScrollRightButtonEnabled: $isScrollRightButtonEnabled,
                               scrollLeftButtonTapped: scrollLeftButtonTapped,
                               scrollRightButtonTapped: scrollRightButtonTapped)
            .padding([.top, .bottom], 8)
            .background(Color.backgroundPrimary)
            .clipShape(.rect( bottomLeadingRadius: RoundedCorners.defaultRadius,
                              bottomTrailingRadius: RoundedCorners.defaultRadius))
            .frame(height: Self.topViewHeight)

            // feedbackView
            HStack() {
                Text("How accurate do you find the forecast?")
                 .padding(8)
                Spacer()
                Button() {
                    shouldShowNotImplemented = true
                } label: {
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color.accentColor)
                }
            }
            .padding(8)
            .background(Color.backgroundPrimary)
            .foregroundColor(Color.accentColor)
            .cornerRadius(RoundedCorners.defaultRadius)
            .frame(height: Self.feedbackViewHeight)

            // bottomView
            HStack() {
                Text("Wind Forecast")
                    .padding(.leading, 8)
                    .font(.largeFontBold)
                Spacer()
                Button() {
                    shouldShowNotImplemented = true
                } label: {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(Color.accentColor)
                }
            }
            .padding([.leading, .trailing], 8)
            .padding([.top, .bottom], 12)
            .background(Color.backgroundPrimary)
            .clipShape(.rect( topLeadingRadius: RoundedCorners.defaultRadius,
                              topTrailingRadius: RoundedCorners.defaultRadius))
            .frame(height: Self.bottomViewHeight)
        }
        .alert(isPresented: $shouldShowNotImplemented) {
            Alert(title: Text(CommonStrings.notYetImplemented), dismissButton: .default(Text("OK")))
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
