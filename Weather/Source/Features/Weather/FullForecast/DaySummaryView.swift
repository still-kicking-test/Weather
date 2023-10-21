//
//  DaySummaryView.swift
//  Weather
//
//  Created by jonathan saville on 10/10/2023.
//

import SwiftUI
import CoreLocation
import WeatherNetworkingKit

struct DaySummaryView: View {
    @ObservedObject var forecastModel: ForecastModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            Text(forecastModel.forecast.daily[safe: forecastModel.day]?.displayable.first?.description ?? "")
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 4) {
                Text("Day")
                    .padding(.leading)
                Text(forecastModel.forecast.daily[safe: forecastModel.day]?.temperature.max.temperatureString ?? "")
                    .font(Font(UIFont.veryLargeFontBold))
                Text("/")
                    .font(Font(UIFont.veryLargeFont))
                Text(forecastModel.forecast.daily[safe: forecastModel.day]?.temperature.min.temperatureString ?? "")
                    .font(Font(UIFont.veryLargeFontBold))
                Text("Night")
               Spacer()
            }
        }
    }
}

struct DaySummaryView_Previews: PreviewProvider {
    static let location = Location(coordinates: CLLocationCoordinate2D(latitude: 41.8933203, longitude: 12.4829321), name: "Rome (Lazio)")
    static let forecast: Forecast = try! MockAPIService().getForecast(for: location.coordinates, from: [location])
    
    static var previews: some View {
        DaySummaryView(forecastModel: ForecastModel(location: location, forecast: forecast, day: 5))
            .preferredColorScheme(.dark)
    }
}
