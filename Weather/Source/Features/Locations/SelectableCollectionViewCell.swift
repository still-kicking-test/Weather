//
//  SelectableCollectionViewCell.swift
//  Weather
//
//  Created by jonathan saville on 13/09/2023.
//

import UIKit

protocol SelectableCollectionViewCellDelegate: AnyObject {
    func changedValue(sender: UISwitch)
}

class SelectableCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var enablingSwitch: UISwitch!
    
    private var location: CDLocation?
    private weak var delegate: SelectableCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .backgroundPrimary()
        name.textColor = UIColor.defaultText()
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
        self.delegate = delegate
        enablingSwitch.isOn = isEnabled
        enablingSwitch.tag = indexPath.row
        name.text = text
    }
    
    @IBAction func didChangeSwitch(sender: UISwitch) {
        delegate?.changedValue(sender: sender)
    }
}
