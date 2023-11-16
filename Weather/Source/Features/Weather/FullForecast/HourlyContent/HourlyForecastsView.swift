//
//  HourlyForecastsView.swift
//  Weather
//
//  Created by jonathan saville on 09/11/2023.
//

import SwiftUI
import CoreLocation
import WeatherNetworkingKit

enum HourlyContentType {
    case wind
    case multiple(FullForecastView.SelectorState)
}

struct HourlyForecastsView: View {
    
    let forecast: Forecast
    let contentType: HourlyContentType
    let numForecastsPerScreen: Int
    
    private let containerWidth = UIScreen.main.bounds.width
    private let horizontalPadding: CGFloat = 16
    private let trailingPadding: CGFloat = 28
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            let timezoneOffset = forecast.timezoneOffset
            
            ForEach(Array(forecast.hourly.enumerated()), id: \.offset) { index, hourlyForecast in
                let width = (containerWidth - horizontalPadding) / CGFloat(numForecastsPerScreen)
                var height: CGFloat {switch contentType { case .multiple: return HourForecastMultipleView.preferredHeight; case .wind: return HourForecastWindView.preferredHeight }}
                let isLastForecast = forecast.hourly.last?.id == hourlyForecast.id
                
                HStack(spacing: 0) {
                    
                    if HourlyForecastsView.shouldDisplaySeparator(for: index, in: forecast.hourly) {
                        HourForecastSeparatorView(day: hourlyForecast.date.shortDayOfWeek(timezoneOffset) ?? "-")
                            .frame(width: width, height: height)
                    }
                    
                    switch contentType {
                    case .multiple(let state):
                        HourForecastMultipleView(hourlyForecast: hourlyForecast,
                                                 timezoneOffset: timezoneOffset,
                                                 selectorState: state)
                        .frame(width: width, height: height)
                        .padding(.trailing, isLastForecast ? trailingPadding : 0)
                        
                    case .wind:
                        HourForecastWindView(hourlyForecast: hourlyForecast,
                                             timezoneOffset: timezoneOffset)
                        .frame(width: width, height: height)
                        .padding(.trailing, isLastForecast ? trailingPadding : 0)
                    }
                }
            }
        }
    }

    private static func shouldDisplaySeparator(for index: Int, in hourlyForecasts: [HourlyForecast]) -> Bool {
        guard let hourlyForecast = hourlyForecasts[safe: index] else { return false }
        let isFirstForecast = hourlyForecasts.first?.id == hourlyForecast.id
        return hourlyForecast.isFirstForecastOfDay && !isFirstForecast
    }
    
    static func indexForScrollRight(from hourlyIndex: Int?, in hourlyForecasts: [HourlyForecast], itemCount numForecastsPerScreen: Int) -> Int {
        guard let hourlyIndex = hourlyIndex else { return 0 }
        var indexDelta = 0
        var separatorCount = 0
        var newIndex = 0
    
        while abs(indexDelta) + separatorCount <= numForecastsPerScreen - 1 {
            newIndex = indexDelta + hourlyIndex
            if newIndex == hourlyForecasts.count - 1 { break }
            separatorCount += shouldDisplaySeparator(for: newIndex, in: hourlyForecasts) ? 1 : 0
            indexDelta += 1
        }
        newIndex -= (shouldDisplaySeparator(for: newIndex, in: hourlyForecasts) ? 1 : 0)
        return min(hourlyForecasts.count - 1, newIndex + 1)
    }

    static func indexForScrollLeft(from hourlyIndex: Int?, in hourlyForecasts: [HourlyForecast], itemCount numForecastsPerScreen: Int) -> Int {
        guard let hourlyIndex = hourlyIndex else { return 0 }
        var indexDelta = -1
        var separatorCount = 0
        var newIndex = 0
    
        while abs(indexDelta) + separatorCount <= numForecastsPerScreen {
            newIndex = indexDelta + hourlyIndex
            if newIndex == 0 { break }
            separatorCount += shouldDisplaySeparator(for: newIndex, in: hourlyForecasts) ? 1 : 0
            indexDelta -= 1
        }
        return max(0, newIndex)
    }
}

struct HourlyForecastsView_Previews: PreviewProvider {
    static let location = Location(coordinates: CLLocationCoordinate2D(latitude: 41.8933203, longitude: 12.4829321), name: "Rome (Lazio)")
    static var forecast: Forecast = try! MockAPIService().getForecast(for: location.coordinates, from: [location])
    
    static var previews: some View {
        HourlyForecastsView(forecast: forecast, contentType: .multiple(.precipitation), numForecastsPerScreen: 6)
            .background(.gray)
            .preferredColorScheme(.dark)
   }
}
