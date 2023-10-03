//
//  BusyViewController.swift
//  Weather
//
//  Created by jonathan saville on 02/10/2023.
//

import Foundation
import UIKit

class BusyViewController: UIViewController {
    var busyIndicator = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.65)

        busyIndicator.translatesAutoresizingMaskIntoConstraints = false
        busyIndicator.startAnimating()
        view.addSubview(busyIndicator)

        busyIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        busyIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func isHidden(_ value: Bool, in vc: UIViewController) {
        if value {
            willMove(toParent: nil)
            view.removeFromSuperview()
            removeFromParent()
        }
        else {
            view.frame = vc.view.frame
            vc.addChild(self)
            vc.view.addSubview(view)
            didMove(toParent: self)
        }
    }
}
