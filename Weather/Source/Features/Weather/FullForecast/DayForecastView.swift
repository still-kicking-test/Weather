//
//  DayForecastView.swift
//  Weather
//
//  Created by jonathan saville on 09/10/2023.
//

import SwiftUI
import CoreLocation
import UIKit

struct DayForecastView: View {

    var forecast: DailyForecast
    
    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: ImageLoader.imageURL(for: forecast.displayable.first?.icon ?? "")) { image in
                image
                   .resizable()
                   .aspectRatio(contentMode: .fit)
            } placeholder: {
              // loadingView
            }
            .frame(height: 40)
            .padding(.bottom, 0)

            Text(forecast.date.shortDayOfWeek)
                .font(Font(UIFont.largeFont))
        }
        .frame(width: UIScreen.main.bounds.width / 4.5) // ensure user sees there is scrollable content
    }
}

struct DayForecastView_Previews: PreviewProvider {
    static let location = Location(coordinates: CLLocationCoordinate2D(latitude: 41.8933203, longitude: 12.4829321), name: "Rome (Lazio)")
    static let forecast: Forecast = try! MockAPIService().getForecast(for: location, from: [location])
    
    static var previews: some View {
        DayForecastView(forecast: forecast.daily.first!)
            .preferredColorScheme(.dark)
    }
}
