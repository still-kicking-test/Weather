//
//  DayForecastView.swift
//  Weather
//
//  Created by jonathan saville on 09/10/2023.
//

import SwiftUI
import CoreLocation
import WeatherNetworkingKit

struct DayForecastView: View {
    var dailyForecast: DailyForecast
    var timezoneOffset: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: ImageLoader.iconURL(for: dailyForecast.displayable.first?.icon ?? "")) { image in
                image
                   .resizable()
                   .aspectRatio(contentMode: .fit)
            } placeholder: {
              // loadingView
            }
            .frame(height: 40)
            .padding(.bottom, 0)

            Text(dailyForecast.date.dayOfWeek(timezoneOffset) ?? "-")
                .font(.largeFont)
                .padding(.bottom, 8)
       }
    }
}

struct DayForecastView_Previews: PreviewProvider {
    static let location = Location(coordinates: CLLocationCoordinate2D(latitude: 41.8933203, longitude: 12.4829321), name: "Rome (Lazio)")
    static let forecast: Forecast = try! MockAPIService().getForecast(for: location.coordinates, from: [location])
    
    static var previews: some View {
        DayForecastView(dailyForecast: forecast.daily.first!, timezoneOffset: 0)
            .preferredColorScheme(.dark)
    }
}
