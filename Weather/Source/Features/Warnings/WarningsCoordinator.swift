//
//  WarningsCoordinator.swift
//  Warnings
//
//  Created by jonathan saville on 31/08/2023.
//

import Foundation
import UIKit
import SwiftUI

class WarningsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setNavigationBarHidden(true, animated: false)
    }

    func start() {
        let vc = UIHostingController(rootView: WarningsView())
        navigationController.pushViewController(vc, animated: false)
    }
}
