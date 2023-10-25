//
//  LocationCollectionViewCell.swift
//  Weather
//
//  Created by jonathan saville on 13/09/2023.
//

import UIKit

class LocationCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var reorderImage: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!

    private var location: CDLocation?
    
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
                   for indexPath: IndexPath) {
        self.location = location
        name.text = location.name
    }

    @objc
    private func deleteLocation(sender: UIButton) {
        print("tapped delete \(sender.tag))")
    }
}
