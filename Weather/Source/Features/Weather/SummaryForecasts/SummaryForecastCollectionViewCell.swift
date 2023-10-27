//
//  SummaryForecastCollectionViewCell.swift
//  Weather
//
//  Created by jonathan saville on 07/09/2023.
//

import UIKit
import WeatherNetworkingKit

class SummaryForecastCollectionViewCell:  WeatherCollectionViewCell {

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

    override func configure(with forecast: Forecast, indexPath: IndexPath) {
        guard let dailyForecast = forecast.daily[safe: indexPath.row] else { return }
        
        timePeriod.text = dailyForecast.date.shortDayOfWeek(forecast.timezoneOffset) ?? "-"
        maxTemp.text = dailyForecast.temperature.max.temperatureString
        minTemp.text = dailyForecast.temperature.min.temperatureString
        
        Task {
            await loadImage(iconId: dailyForecast.displayable.first?.icon)
        }
    }
    
    private func loadImage(iconId: String?) async {
        guard let iconId = iconId else { return }
        try! await imageView.image = ImageLoader.shared.fetchIcon(for: iconId)
    }
}
