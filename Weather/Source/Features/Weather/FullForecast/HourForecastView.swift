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

    var body: some View {
        VStack(spacing: 8) {
            Text(hourlyForecast.date.formattedTime)

            AsyncImage(url: ImageLoader.iconURL(for: hourlyForecast.displayable.first?.icon ?? "")) { image in
                image
                   .resizable()
                   .aspectRatio(contentMode: .fit)
            } placeholder: {
              // loadingView
            }
            .frame(height: 40)
            .padding(.bottom, 12)

            Text(hourlyForecast.temp.temperatureString)
                .foregroundColor(.black)
                .frame(width: 35, height: 35)
                .background(Color(UIColor.colour(for: hourlyForecast.temp)))
                .cornerRadius(4)
                .padding(.bottom, 4)
 
            Text(hourlyForecast.feels_like.temperatureString)
                .padding(.bottom, 8)
       }
        .frame(width: (UIScreen.main.bounds.width - 16) / 6)
    }
}

struct HourForecastView_Previews: PreviewProvider {
    static let location = Location(coordinates: CLLocationCoordinate2D(latitude: 41.8933203, longitude: 12.4829321), name: "Rome (Lazio)")
    static let forecast: Forecast = try! MockAPIService().getForecast(for: location.coordinates, from: [location])
    
    static var previews: some View {
        HourForecastView(hourlyForecast: forecast.hourly.first!)
            .preferredColorScheme(.dark)
    }
}
