//
//  WeatherCoordinator.swift
//  Weather
//
//  Created by jonathan saville on 31/08/2023.
//

import Foundation
import UIKit
import SwiftUI

protocol WeatherCoordinatorProtocol: NSObject, Coordinator {
    func showEdit()
    func showSettings()
    func showFullForecast(_ forecast: Forecast, day: Int)
}

class WeatherCoordinator: NSObject, WeatherCoordinatorProtocol {

    let apiService: APIServiceProtocol
    let settingsManager: SettingsManager
    let locationManager: LocationManagerProtocol
    let coreDataManager: CoreDataManager

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController,
         apiService: APIServiceProtocol,
         settingsManager: SettingsManager,
         locationManager: LocationManagerProtocol,
         coreDataManager: CoreDataManager) {
        self.navigationController = navigationController
        self.apiService = apiService
        self.settingsManager = settingsManager
        self.locationManager = locationManager
        self.coreDataManager = coreDataManager
    }

    func start() {
        let vc = WeatherViewController.fromNib()
        let viewModel = WeatherViewModel(apiService: apiService,
                                         settingsManager: settingsManager,
                                         locationManager: locationManager,
                                         coreDataManager: coreDataManager)
        vc.viewModel = viewModel
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
 
    func showEdit() {
        let vc = LocationsViewController.fromNib()
        let viewModel = LocationsViewModel(apiService: apiService,
                                           settingsManager: settingsManager,
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
        guard let location = forecast.location else { return }
        print("Showing full forecast for \(location.name), day: \(forecast.daily[day].date.shortDayOfWeek)")
        let vc = FullForecastViewController.fromNib()
        navigationController.topViewController?.present(vc,animated: true)
    }
}
