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
    
    convenience init(title: String,
                     attributes: AttributeContainer = AttributeContainer([NSAttributedString.Key.foregroundColor: UIColor.button(for: .highlighted)]),
                     isUserInteractionEnabled: Bool = true,
                     numberOfLines: Int = 0,
                     contentHorizontalAlignment: UIControl.ContentHorizontalAlignment = .left,
                     contentInsets: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0))
                   
    {
        self.init()
        var config = UIButton.Configuration.plain()
        config.contentInsets = contentInsets
        configuration = config

        self.isUserInteractionEnabled = isUserInteractionEnabled
        self.titleLabel?.numberOfLines = numberOfLines
        self.contentHorizontalAlignment = contentHorizontalAlignment
        
        let attrTitle = NSAttributedString(AttributedString(title, attributes: attributes))
        setAttributedTitle(attrTitle, for: .normal)
    }
}
