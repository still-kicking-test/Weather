//
//  MapsCoordinator.swift
//  Maps
//
//  Created by jonathan saville on 31/08/2023.
//

import Foundation
import UIKit

protocol MapsCoordinatorProtocol: Coordinator {
    func pressMeTapped()
}

class MapsCoordinator: MapsCoordinatorProtocol {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setNavigationBarHidden(true, animated: false)
    }

    func start() {
        let vc = MapsViewController.fromNib()
        vc.coordinator = self
        vc.viewModel = MapsViewModel()
        navigationController.pushViewController(vc, animated: false)
    }
 
    func pressMeTapped() {
    }
}
