//
//  TabBarCoordinator.swift
//  Weather
//
//  Created by jonathan saville on 01/09/2023.
//

import Foundation
import UIKit

protocol TabCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    
    var currentTab: TabBarItem? { get }
    func selectTab(_ page: TabBarItem)
    func setSelectedIndex(_ index: Int)
}

class TabBarCoordinator: NSObject, TabCoordinatorProtocol {
        
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var tabBarController: UITabBarController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = TabBarController()
    }

    func start() {
        let tabs: [TabBarItem] = [.weather, .maps, .warnings]
            .sorted(by: { $0 < $1 })
        
        let coordinators: [Coordinator] = tabs.map({ getTabCoordinator($0) })
        
        prepareTabBarController(coordinators)
    }
    
    var currentTab: TabBarItem? {
        TabBarItem(rawValue: tabBarController.selectedIndex)
    }

    func selectTab(_ tabBarItem: TabBarItem) {
        tabBarController.selectedIndex = tabBarItem.order
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let tabBarItem = TabBarItem.init(rawValue: index) else { return }
        tabBarController.selectedIndex = tabBarItem.order
    }

    private func prepareTabBarController(_ tabControllers: [Coordinator]) {
        tabBarController.setViewControllers(tabControllers.compactMap { $0.navigationController }, animated: false)
        navigationController.viewControllers = [tabBarController]
    }
      
    private func getTabCoordinator(_ tabBarItem: TabBarItem) -> Coordinator {
        let coordinator: Coordinator
        let navController = UINavigationController()

        navController.tabBarItem = UITabBarItem.init(title: tabBarItem.title,
                                                     image: UIImage(systemName: tabBarItem.icon),
                                                     tag: tabBarItem.order)

        switch tabBarItem {
        case .weather:
            coordinator = WeatherCoordinator(navigationController: navController)
        case .maps:
            coordinator = MapsCoordinator(navigationController: navController)
        case .warnings:
            coordinator = WarningsCoordinator(navigationController: navController)
        }
        coordinator.start()
        return coordinator
    }
}
