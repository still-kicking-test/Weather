//
//  SearchCollectionViewCell.swift
//  Weather
//
//  Created by jonathan saville on 13/09/2023.
//

import UIKit

protocol SearchCollectionViewCellDelegate: AnyObject {
    func searchTapped()
}

class SearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var button: UIButton! // to be replaced with a UITextfield when I get access to a decent city search API

    private var location: CDLocation?
    private weak var delegate: SearchCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .backgroundPrimary()
        icon.tintColor = UIColor.defaultText()
        button.titleLabel?.font = UIFont.defaultFont
        button.setTitleColor(UIColor.defaultText().withAlphaComponent(0.6), for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    func configure(with placeholderText: String,
                   delegate: SearchCollectionViewCellDelegate) {
        self.delegate = delegate
        button.setTitle(placeholderText, for: .normal)
    }
    
    // to be replaced with UITextfield input when I get access to a decent city search API
    @IBAction func didTapSearch(sender: UIButton) {
        delegate?.searchTapped()
    }
}
