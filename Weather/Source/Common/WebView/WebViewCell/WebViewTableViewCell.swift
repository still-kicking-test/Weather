//
//  WebViewTableViewCell.swift
//  Weather
//
//  Created by jonathan saville on 04/10/2023.
//

import UIKit
import WebKit

class WebViewTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        webView.scrollView.isScrollEnabled = false
        backgroundColor = .backgroundPrimary()
        selectionStyle = .none
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }

    func configure(with title: String, url: URL) {
        titleLabel.attributedText = NSAttributedString(string: title,
                                                       attributes: [
                                                        .font : UIFont.boldSystemFont(ofSize: 18.0),
                                                        .foregroundColor: UIColor.defaultText()
                                                       ])
        webView.load(URLRequest(url: url))
    }
}
