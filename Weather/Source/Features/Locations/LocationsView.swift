//
//  LocationsView.swift
//  Weather
//
//  Created by jonathan saville on 15/03/2024.
//

import SwiftUI
import Combine

struct LocationsView: UIViewControllerRepresentable {

    @EnvironmentObject var appState: AppState

    private var cancellables = Set<AnyCancellable>()

    func makeUIViewController(context: Self.Context) -> LocationsViewController {
        let viewModel = LocationsViewModel(appState: appState)
        let viewController = LocationsViewController.fromNib()
        viewController.viewModel = viewModel
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: LocationsViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}
