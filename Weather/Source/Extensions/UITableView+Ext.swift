//
//  UITableView+Ext.swift
//  Weather
//
//  Created by jonathan saville on 04/09/2023.
//

import UIKit

extension UITableView {
        
    func registerCell(withType type: UITableViewCell.Type, identifier: String? = nil) {
        let nibName = String(describing: type)
        register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: identifier ?? nibName)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withType type: UITableViewCell.Type) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier) as? T
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withType type: UITableViewCell.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T
    }
}
