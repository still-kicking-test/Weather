//
//  UIViewController+Extensions.swift
//  Weather
//
//  Created by jonathan saville on 31/08/2023.
//

import UIKit

extension UIViewController {
    
    static func fromNib() -> Self {
        func instantiateFromNib<T: UIViewController>(_ viewType: T.Type) -> T {
            T.init(nibName: String(describing: T.self), bundle: nil)
        }
        return instantiateFromNib(self)
    }
    
    func showDismissableError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alertController, animated: true)
    }
}
