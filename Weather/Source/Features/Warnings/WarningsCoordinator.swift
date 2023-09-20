//
//  WarningsCoordinator.swift
//  Warnings
//
//  Created by jonathan saville on 31/08/2023.
//

import Foundation
import UIKit

protocol WarningsCoordinatorProtocol: Coordinator {
    func pressMeTapped()
}

class WarningsCoordinator: WarningsCoordinatorProtocol {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setNavigationBarHidden(true, animated: false)
    }

    func start() {
        let vc = WarningsViewController.fromNib()
        vc.coordinator = self
        vc.viewModel = WarningsViewModel()
        navigationController.pushViewController(vc, animated: false)
    }
 
    func pressMeTapped() {
    }
}
