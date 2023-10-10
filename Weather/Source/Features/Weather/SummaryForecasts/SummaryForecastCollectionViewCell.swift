//
//  SummaryForecastCollectionViewCell.swift
//  Weather
//
//  Created by jonathan saville on 07/09/2023.
//

import UIKit

class SummaryForecastCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var timePeriod: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .backgroundPrimary()
        imageViewHeightConstraint.constant = 40
        
        timePeriod.font = .defaultFont
        timePeriod.textColor = UIColor.defaultText()
        maxTemp.font = .largeFont
        maxTemp.textColor = UIColor.defaultText()
        minTemp.font = .defaultFont
        minTemp.textColor = UIColor.defaultText()
    }

    func configure(with dailyForecast: DailyForecast) {
        timePeriod.text = dailyForecast.date.shortDayOfWeek
        maxTemp.text = dailyForecast.temperature.max.temperatureString
        minTemp.text = dailyForecast.temperature.max.temperatureString
        
        Task {
            await loadImage(iconId: dailyForecast.displayable.first?.icon)
        }
    }
    
    func loadImage(iconId: String?) async {
        guard let iconId = iconId else { return }
        try! await imageView.image = ImageLoader.shared.fetchIcon(id: iconId)
    }
}
