//
//  NotificationsView.swift
//  Weather
//
//  Created by jonathan saville on 26/09/2023.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text(AlertMessage.notYetImplemented)
                .foregroundColor(Color(.button(for: .highlighted)))
        }
        .navigationTitle("Notifications")
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
            .preferredColorScheme(.dark)
    }
}
