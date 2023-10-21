//
//  FullForecastView.swift
//  Weather
//
//  Created by jonathan saville on 09/10/2023.
//

import SwiftUI
import CoreLocation
import WeatherNetworkingKit

struct FullForecastView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var forecastModel: ForecastModel

    var body: some View {
        NavigationStack() {
            
            ZStack {
                Color(UIColor.navbarBackground()).ignoresSafeArea()

                VStack(spacing: 0) {
                    Divider()
                        .background(Color(UIColor.backgroundPrimary()))
                    Text(forecastModel.location.fullName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font(UIFont.largeFontBold))
                        .padding([.bottom, .leading, .trailing])
                    .background(Color(UIColor.backgroundPrimary()))

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 0) {
                            ForEach(Array(forecastModel.forecast.daily.enumerated()), id: \.offset) { index, dailyForecast in
                                DayForecastView(dailyForecast: dailyForecast)
                                    .background(forecastModel.day == index ? Color(UIColor.navbarBackground()) : Color(UIColor.backgroundPrimary()))
                                    .overlay(forecastModel.day == index ?
                                             RoundedRectangle(cornerRadius: 8).stroke(.white, lineWidth: 1) : nil
                                    )
                                    .onTapGesture() {
                                        forecastModel.day = index
                                    }
                             }
                        }
                    }
                    .background(Color(UIColor.backgroundPrimary()))

                    DaySummaryView(forecastModel: forecastModel)
                        .padding([.top, .bottom])

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 0) {
                            ForEach(forecastModel.forecast.hourly) { hourlyForecast in
                                HourForecastView(hourlyForecast: hourlyForecast)
                            }
                        }
                    }
                    .padding([.top, .bottom], 8)
                    .background(Color(UIColor.backgroundPrimary()))
                    .cornerRadius(12)
                    .padding([.leading, .trailing], 8)

                    Spacer()
                }
                .foregroundColor(Color(UIColor.defaultText()))
                .font(Font(UIFont.defaultFont))
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.hidden, for: .navigationBar)
                .toolbar {
                    Group {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Close", role: .cancel) { dismiss() }
                                .buttonStyle(PrimaryButtonStyle())
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                            }
                            .buttonStyle(PrimaryButtonStyle())
                        }
                    }
                }
            }
        }
    }
}

struct FullForecastView_Previews: PreviewProvider {
    static let location = Location(coordinates: CLLocationCoordinate2D(latitude: 41.8933203, longitude: 12.4829321), name: "Rome (Lazio)")
    static let forecast: Forecast = try! MockAPIService().getForecast(for: location.coordinates, from: [location])
    
    static var previews: some View {
        FullForecastView(forecastModel: ForecastModel(location: location, forecast: forecast, day: 5))
        .preferredColorScheme(.dark)
   }
}

