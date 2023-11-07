//
//  InlineMessageTableViewCell.swift
//  Weather
//
//  Created by jonathan saville on 07/11/2023.
//

import UIKit

class InlineMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .backgroundPrimary()
        selectionStyle = .none
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }

    func configure(with inlineMessage: InlineMessage) {
        messageLabel.attributedText = NSAttributedString(string: inlineMessage.text,
                                                         attributes: [
                                                            .font : UIFont.defaultFont,
                                                            .foregroundColor: UIColor.button(for: .highlighted)
                                                         ])
    }
}
