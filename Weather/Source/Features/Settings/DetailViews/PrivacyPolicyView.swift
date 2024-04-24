//
//  PrivacyPolicyView.swift
//  Weather
//
//  Created by jonathan saville on 26/09/2023.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text(CommonStrings.notYetImplemented)
                .foregroundColor(.defaultText)
        }
        .navigationTitle("Privacy policy")
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyView()
            .preferredColorScheme(.dark)
    }
}
