//
//  TabBarController.swift
//  Weather
//
//  Created by jonathan saville on 19/09/2023.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientColorFrom = UIColor.backgroundGradientFrom().cgColor
        let gradientColorTo = UIColor.backgroundGradientTo().cgColor
        view.layer.configureGradientBackground(gradientColorFrom, gradientColorTo)
    }
}
