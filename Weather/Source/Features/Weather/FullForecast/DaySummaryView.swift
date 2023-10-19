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
    @State var forecast: DailyForecast
    
    var body: some View {
        VStack(spacing: 0) {
            
            Text(forecast.displayable.first?.description ?? "")
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 4) {
                Text("Day")
                    .font(Font(UIFont.defaultFontBold))
                    .padding(.leading)
                Text(forecast.temperature.max.temperatureString)
                    .font(Font(UIFont.largeFontBold))
                Text("/")
                Text(forecast.temperature.min.temperatureString)
                    .font(Font(UIFont.largeFont))
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
        DaySummaryView(forecast: forecast.daily.first!)
            .preferredColorScheme(.dark)
    }
}
