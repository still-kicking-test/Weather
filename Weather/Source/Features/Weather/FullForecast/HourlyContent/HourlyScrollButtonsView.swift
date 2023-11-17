//
//  HourlyScrollButtonsView.swift
//  Weather
//
//  Created by jonathan saville on 17/11/2023.
//

import SwiftUI

struct HourlyScrollButtonsView: View {

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
    }
}

struct HourlyScrollButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        TwoStatesPreviewWrapper(false, true) { HourlyScrollButtonsView(isScrollLeftButtonEnabled: $0,
                                                                       isScrollRightButtonEnabled: $1,
                                                                       scrollLeftButtonTapped: {},
                                                                       scrollRightButtonTapped: {}) }
        .background(.gray)
        .preferredColorScheme(.dark)
    }
}
