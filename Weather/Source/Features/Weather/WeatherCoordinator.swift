//
//  WeatherCoordinator.swift
//  Weather
//
//  Created by jonathan saville on 31/08/2023.
//

import Foundation
import UIKit
import SwiftUI
import WeatherNetworkingKit

protocol WeatherCoordinatorProtocol: NSObject, Coordinator {
    func showEdit()
    func showSettings()
    func showFullForecast(_ forecast: Forecast, day: Int)
}

class WeatherCoordinator: NSObject, WeatherCoordinatorProtocol {

    let apiService: APIServiceProtocol
    let locationManager: LocationManagerProtocol
    let coreDataManager: CoreDataManager

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController,
         apiService: APIServiceProtocol,
         locationManager: LocationManagerProtocol,
         coreDataManager: CoreDataManager) {
        self.navigationController = navigationController
        self.apiService = apiService
        self.locationManager = locationManager
        self.coreDataManager = coreDataManager
    }

    func start() {
        let vc = WeatherViewController.fromNib()
        let viewModel = WeatherViewModel(apiService: apiService,
                                         locationManager: locationManager,
                                         coreDataManager: coreDataManager)
        vc.viewModel = viewModel
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
 
    func showEdit() {
        let vc = LocationsViewController.fromNib()
        let viewModel = LocationsViewModel(apiService: apiService,
                                           locationManager: locationManager,
                                           coreDataManager: coreDataManager)

        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showSettings() {
        let vc = UIHostingController(rootView: SettingsView())
        navigationController.topViewController?.present(vc, animated: true)
    }

    func showFullForecast(_ forecast: Forecast, day: Int) {
        let vc = UIHostingController(rootView: FullForecastView(forecast: forecast, selectedDay: day))
        navigationController.topViewController?.present(vc, animated: true)
    }
}
