//
//  Coordinator.swift
//  Weather
//
//  Created by jonathan saville on 31/08/2023.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
    func popToRoot(animated: Bool)
}

extension Coordinator {
    func popToRoot(animated: Bool = true) {
        navigationController.popToRootViewController(animated: animated)
    }
}
