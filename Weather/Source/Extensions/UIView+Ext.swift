//
//  UIView+Ext.swift
//  Weather
//
//  Created by jonathan saville on 20/10/2023.
//

import UIKit

extension UIView {
    func pinEdges(to container: UIView) {
        leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
    }
    
    func removeAllSubviews() {
        subviews.forEach { subView in
            subView.removeFromSuperview()
        }
    }
}
