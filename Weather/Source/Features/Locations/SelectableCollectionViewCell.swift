//
//  SelectableCollectionViewCell.swift
//  Weather
//
//  Created by jonathan saville on 13/09/2023.
//

import UIKit

protocol SelectableCollectionViewCellDelegate: AnyObject {
    func changedValue()
}

class SelectableCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var enablingSwitch: UISwitch!
    
    private var location: Location?
    private weak var delegate: SelectableCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .backgroundPrimary()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    func configure(with isEnabled: Bool,
                   text: String,
                   for indexPath: IndexPath,
                   delegate: SelectableCollectionViewCellDelegate) {
        self.enablingSwitch.isOn = isEnabled
        self.delegate = delegate
        name.text = text
    }
    
    @IBAction func didChangeSwitch(sender: UISwitch) {
        delegate?.changedValue()
    }
}
