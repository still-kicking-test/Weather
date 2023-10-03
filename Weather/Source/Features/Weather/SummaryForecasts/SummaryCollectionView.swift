//
//  SummaryCollectionView.swift
//  Weather
//
//  Created by jonathan saville on 08/09/2023.
//

import UIKit

class SummaryCollectionView: UICollectionView {
    /*
     @IBOutlet weak var heightConstraint: NSLayoutConstraint!
     
     override func willLayoutSubviews() {
     super.viewWillLayoutSubviews()
     heightConstraint.constant = collectionViewLayout.collectionViewContentSize.height
     }
     }
     
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = myCollectionView.collectionViewLayout.collectionViewContentSize.height
        myCollectionViewHeight.constant = height
        self.view.layoutIfNeeded()
    }
     */
/*
    override func layoutSubviews() {
        super.layoutSubviews()
        heightConstraint.constant = collectionViewLayout.collectionViewContentSize.height

      //  if bounds.size != intrinsicContentSize {
      //      self.invalidateIntrinsicContentSize()
      //  }
    }
    
    override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
    }
 */

/*
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            print("invalidateIntrinsicContentSize")
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        print("contentSize: \(contentSize)")
        return CGSize(width: 1094, height: 195)
    }
 */
}
