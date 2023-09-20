//
//  UIButton+Ext.swift
//  Weather
//
//  Created by jonathan saville on 31/08/2023.
//

import UIKit

extension UIButton {

    var normalTitleText: String? {
        get {
            title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
    
    func configure(baseForegroundColor: UIColor = .button(for: .normal)) {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = baseForegroundColor
        configuration = config
        // config.cornerStyle = .large
        // config.titleAlignment = .center
    }
}
