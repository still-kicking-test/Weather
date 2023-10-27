//
//  HourForecastView.swift
//  Weather
//
//  Created by jonathan saville on 09/10/2023.
//

import SwiftUI
import CoreLocation
import UIKit
import WeatherNetworkingKit

struct HourForecastView: View {
    var hourlyForecast: HourlyForecast
    var timezoneOffset: Int
    var selectorState: FullForecastView.SelectorState

    // Other views need this view's height - fastest & most straightforward way is to construct it from its known structure...
    static let preferredHeight = Constants.font.lineHeight + // time
                                 Constants.iconHeight + Constants.iconPaddingBottom +  // icon
                                 Constants.temperatureHeight + Constants.temperaturePaddingBottom  + // temperature
                                 Constants.font.lineHeight  + // feels-like temperature
                                (verticalSpacing * 4)

    static let verticalSpacing: CGFloat = 8
    enum Constants {
        static let iconHeight: CGFloat = 40
        static let iconPaddingBottom: CGFloat = 12
        static let temperatureHeight: CGFloat = 35
        static let temperaturePaddingBottom: CGFloat = 4
        static let font = UIKit.UIFont.defaultFont
    }

    var body: some View {
        VStack(spacing: HourForecastView.verticalSpacing) {
            // time
            Text(hourlyForecast.detail != nil ? (hourlyForecast.date.formattedTime(timezoneOffset) ?? "-") : "-")
                .font(Font(Constants.font))

            // icon
            if let hourlyForecastDetail = hourlyForecast.detail {
                AsyncImage(url: ImageLoader.iconURL(for: hourlyForecastDetail.displayable.first?.icon ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    // loadingView
                }
                .frame(height: Constants.iconHeight)
                .padding(.bottom, Constants.iconPaddingBottom)
            } else {
                Text("No data")
                    .font(Font(Constants.font))
                    .frame(height: Constants.iconHeight)
                    .padding(.bottom, Constants.iconPaddingBottom)
            }

            // temperature
            Text(hourlyForecast.detail?.temp.temperatureString ?? "-")
                .font(Font(Constants.font))
                .foregroundColor(hourlyForecast.detail == nil ? Color(.defaultText()) : .black)
                .frame(width: Constants.temperatureHeight, height: Constants.temperatureHeight)
                .background(Color(UIColor.colour(for: hourlyForecast.detail?.temp)))
                .cornerRadius(4)
                .padding(.bottom, Constants.temperaturePaddingBottom)

            // feels-like temperature OR liklihood of precipitation
            Text(selectorState == .precipitation ? (hourlyForecast.detail?.precipitation.precipitationString ?? "-") : (hourlyForecast.detail?.feels_like.temperatureString ?? "-"))
                .font(Font(Constants.font))
                .padding(.bottom, HourForecastView.verticalSpacing)
        }
    }
}

struct HourForecastView_Previews: PreviewProvider {
    static let location = Location(coordinates: CLLocationCoordinate2D(latitude: 41.8933203, longitude: 12.4829321), name: "Rome (Lazio)")
    static let forecast: Forecast = try! MockAPIService().getForecast(for: location.coordinates, from: [location])
    
    static var previews: some View {
        HourForecastView(hourlyForecast: forecast.hourly.first!, timezoneOffset: 0, selectorState: .precipitation)
            .preferredColorScheme(.dark)
            .frame(width: 60, height: HourForecastView.preferredHeight)
    }
}
