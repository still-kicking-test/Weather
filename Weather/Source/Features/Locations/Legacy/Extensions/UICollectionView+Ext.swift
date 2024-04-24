//
//  UICollectionView+Ext.swift
//  Weather
//
//  Created by jonathan saville on 07/09/2023.
//

import UIKit

extension UICollectionView {
        
    func registerCell(withType type: UICollectionViewCell.Type, identifier: String? = nil) {
        let nibName = String(describing: type)
        register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: identifier ?? nibName)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(withType type: UICollectionViewCell.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? T
    }
    
    func isCellAtIndexPathFullyVisible(_ indexPath: IndexPath) -> Bool {
        guard let layoutAttribute = layoutAttributesForItem(at: indexPath) else { return false }
        return bounds.contains(layoutAttribute.frame)
    }

    var indexPathsForFullyVisibleItems: [IndexPath] {
        let visibleIndexPaths = indexPathsForVisibleItems
        return visibleIndexPaths.filter { indexPath in
            isCellAtIndexPathFullyVisible(indexPath)
        }
    }
}
