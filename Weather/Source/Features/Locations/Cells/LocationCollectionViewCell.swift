//
//  LocationCollectionViewCell.swift
//  Weather
//
//  Created by jonathan saville on 13/09/2023.
//

import UIKit

protocol LocationCollectionViewCellProtocol: NSObject {
    func didTapDeleteForCell(_ cell: LocationCollectionViewCell)
}

class LocationCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var reorderImage: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!

    private var location: CDLocation?
    private weak var delegate: LocationCollectionViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .backgroundPrimary()
        name.textColor = UIColor.defaultText()
        reorderImage.tintColor = .divider()
        deleteButton.tintColor = .red
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    func configure(with location: CDLocation,
                   delegate: LocationCollectionViewCellProtocol) {
        self.location = location
        self.delegate = delegate
        name.text = location.name
    }

    @IBAction
    func deleteLocation(sender: UIButton) {
        delegate?.didTapDeleteForCell(self)
    }
}
