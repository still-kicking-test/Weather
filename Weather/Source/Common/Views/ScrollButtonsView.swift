//
//  ScrollButtonsView.swift
//  Weather
//
//  Created by jonathan saville on 17/11/2023.
//

import SwiftUI

struct ScrollButtonsView: View {

    @Binding var isScrollLeftButtonEnabled: Bool
    @Binding var isScrollRightButtonEnabled: Bool
    var scrollLeftButtonTapped: () -> Void
    var scrollRightButtonTapped: () -> Void

    var body: some View {
        HStack() {
            Spacer()
            HStack(spacing: 16) {
                Button(action: { scrollLeftButtonTapped() }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(isScrollLeftButtonEnabled ? .accentColor : .divider)
                }
                .disabled(!isScrollLeftButtonEnabled)
                
                Rectangle()
                    .fill(Color.divider)
                    .frame(width: 1)

                Button(action: { scrollRightButtonTapped() }) {
                    Image(systemName: "chevron.forward")
                        .foregroundColor(isScrollRightButtonEnabled ? .accentColor : .divider)
                }
                .disabled(!isScrollRightButtonEnabled)
           }
            .frame(height: 32)
            .padding([.trailing], 24)
        }
    }
}

struct ScrollButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        TwoStatesPreviewWrapper(false, true) { ScrollButtonsView(isScrollLeftButtonEnabled: $0,
                                                                 isScrollRightButtonEnabled: $1,
                                                                 scrollLeftButtonTapped: {},
                                                                 scrollRightButtonTapped: {}) }
        .background(.gray)
        .preferredColorScheme(.dark)
    }
}
