//
//  LocationCollectionViewCell.swift
//  Weather
//
//  Created by jonathan saville on 13/09/2023.
//

import UIKit

protocol LocationCollectionViewCellDelegate: AnyObject {
    func tappedCell()
}

class LocationCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var reorderImage: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!

    private var location: Location?
    private weak var delegate: LocationCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .backgroundPrimary()
        reorderImage.tintColor = .backgroundTertiary()
        deleteButton.tintColor = .red
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    func configure(with location: Location,
                   for indexPath: IndexPath,
                   delegate: LocationCollectionViewCellDelegate) {
        self.location = location
        self.delegate = delegate
        name.text = location.name
    }

    @objc
    private func deleteLocation(sender: UIButton) {
        print("tapped delete \(sender.tag))")
    }
}
