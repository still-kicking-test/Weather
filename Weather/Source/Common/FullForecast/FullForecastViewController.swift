//
//  FullForecastViewController.swift
//  Weather
//
//  Created by jonathan saville on 01/09/2023.
//

import UIKit

class FullForecastViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    private func initUI() {
        view.backgroundColor = .backgroundPrimary()
        closeButton.tintColor = .button(for: .highlighted)
    }
    
    @IBAction func close(sender: UIButton) {
        self.dismiss(animated: true)
    }
}
