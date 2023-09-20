//
//  CALayer+Ext.swift
//  Weather
//
//  Created by jonathan saville on 19/09/2023.
//

import UIKit

extension CALayer {
    
    public func configureGradientBackground(_ colors: CGColor...) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors
        self.insertSublayer(gradient, at: 0)
    }
}
