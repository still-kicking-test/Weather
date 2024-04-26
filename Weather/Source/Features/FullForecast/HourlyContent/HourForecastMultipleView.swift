//
//  HourForecastMultipleView.swift
//  Weather
//
//  Created by jonathan saville on 10/11/2023.
//

import SwiftUI
import CoreLocation
import WeatherNetworkingKit

struct HourForecastMultipleView: View {
    var hourlyForecast: HourlyForecast
    var timezoneOffset: Int
    var selectorState: FullForecastView.SelectorState

    // HourlyForecastView & FullforecastView need this view's height - fastest & most straightforward way is to construct it from its known structure...
    static let preferredHeight = Constants.fontLineHeight + verticalSpacing +// time
                                 Constants.iconHeight + Constants.iconPaddingBottom + verticalSpacing + // icon
                                 Constants.temperatureHeight + Constants.temperaturePaddingBottom + verticalSpacing + // temperature
                                 Constants.fontLineHeight // feels-like temperature

    private static let verticalSpacing: CGFloat = 8
    
    private enum Constants {
        static let iconHeight: CGFloat = 40
        static let iconPaddingBottom: CGFloat = 12
        static let temperatureHeight: CGFloat = 35
        static let temperaturePaddingBottom: CGFloat = 4
        static let font = Font.defaultFont
        static let fontLineHeight = Font.defaultFontLineHeight
    }

    var body: some View {
        VStack(spacing: HourForecastMultipleView.verticalSpacing) {
            // time
            Text(hourlyForecast.detail != nil ? (hourlyForecast.date.formattedTime(timezoneOffset) ?? "-") : "-")
                .font(Constants.font)

            // icon
            if let hourlyForecastDetail = hourlyForecast.detail {
                WeatherIcon(fromOpenWeatherCode: hourlyForecastDetail.displayable.first?.icon ?? "")
                    .frame(height: Constants.iconHeight)
                    .padding(.bottom, Constants.iconPaddingBottom)
            } else {
                Text("No data")
                    .font(Constants.font)
                    .frame(height: Constants.iconHeight)
                    .padding(.bottom, Constants.iconPaddingBottom)
            }

            // temperature
            Text(hourlyForecast.detail?.temp.temperatureString ?? "-")
                .font(Constants.font)
                .foregroundColor(hourlyForecast.detail == nil ? .defaultText : .black)
                .frame(width: Constants.temperatureHeight, height: Constants.temperatureHeight)
                .background(Color.colour(forDegreesCelsius: hourlyForecast.detail?.temp))
                .cornerRadius(4)
                .padding(.bottom, Constants.temperaturePaddingBottom)

            // feels-like temperature OR liklihood of precipitation
            Text(selectorState == .precipitation ? (hourlyForecast.detail?.precipitation.precipitationString ?? "-") : (hourlyForecast.detail?.feels_like.temperatureString ?? "-"))
                .font(Constants.font)
                .foregroundColor(selectorState == .precipitation ? .colour(forPrecipitation: hourlyForecast.detail?.precipitation) : .defaultText)
        }
    }
}

struct HourForecastMultipleView_Previews: PreviewProvider {
    static let location = Location(coordinates: CLLocationCoordinate2D(latitude: 41.8933203, longitude: 12.4829321), name: "Rome (Lazio)")
    static let forecast: Forecast = try! MockAPIService().getForecast(for: location.coordinates, from: [location])
    
    static var previews: some View {
        HourForecastMultipleView(hourlyForecast: forecast.hourly.first!, timezoneOffset: 0, selectorState: .precipitation)
            .preferredColorScheme(.dark)
            .frame(width: 60, height: HourForecastMultipleView.preferredHeight)
            .background(.gray)
    }
}
