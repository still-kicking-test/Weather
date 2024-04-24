//
//  HourForecastWindView.swift
//  Weather
//
//  Created by jonathan saville on 10/11/2023.
//

import SwiftUI
import CoreLocation
import WeatherNetworkingKit

struct HourForecastWindView: View {
    var hourlyForecast: HourlyForecast
    var timezoneOffset: Int

    // HourlyForecastView & FullforecastView need this view's height - fastest & most straightforward way is to construct it from its known structure...
    static let preferredHeight = Constants.fontLineHeight + verticalSpacing + // time
                                 Constants.iconHeight + verticalSpacing + // icon
                                 Constants.fontLineHeight  + verticalSpacing + // wind speed
                                 Constants.fontLineHeight  + verticalSpacing + // wind gust
                                 Constants.fontLineHeight // wind direction

    private static let verticalSpacing: CGFloat = 8
    
    private enum Constants {
        static let iconHeight: CGFloat = 40
        static let font = Font.defaultFont
        static let fontLineHeight = Font.defaultFontLineHeight
    }

    var body: some View {
        VStack(spacing: HourForecastWindView.verticalSpacing) {
            // time
            Text(hourlyForecast.detail != nil ? (hourlyForecast.date.formattedTime(timezoneOffset) ?? "-") : "-")
                .font(Constants.font)

            // icon
            if let hourlyForecastDetail = hourlyForecast.detail {
                Image(systemName: "location.fill")
                    .renderingMode(.template)
                    .rotationEffect(.degrees(Double(hourlyForecastDetail.windDirection) - 225))
                    .foregroundColor(.windAndRain)
                    .frame(height: Constants.iconHeight)
                    .padding(.bottom, 0)
            } else {
                Text("No data")
                    .font(Constants.font)
                    .frame(height: Constants.iconHeight)
                    .padding(.bottom, 0)
            }

            // Wind speed
            Text(hourlyForecast.detail?.windSpeed.windSpeedString ?? "-")
                .font(Constants.font)
            
            // Wind gust
            Text(hourlyForecast.detail?.windGust.windSpeedString ?? "-")
                .font(Constants.font)
            
            // Wind direction
            Text(hourlyForecast.detail?.windDirection.windDirection.rawValue ?? "-")
                .font(Constants.font)
        }
    }
}

struct HourForecastWindView_Previews: PreviewProvider {
    static let location = Location(coordinates: CLLocationCoordinate2D(latitude: 41.8933203, longitude: 12.4829321), name: "Rome (Lazio)")
    static let forecast: Forecast = try! MockAPIService().getForecast(for: location.coordinates, from: [location])
    
    static var previews: some View {
        HourForecastWindView(hourlyForecast: forecast.hourly.first!, timezoneOffset: 0)
            .preferredColorScheme(.dark)
            .frame(width: 60, height: HourForecastWindView.preferredHeight)
            .background(.gray)
    }
}
