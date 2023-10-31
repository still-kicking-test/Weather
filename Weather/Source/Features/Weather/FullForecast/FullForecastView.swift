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
    @State var slidingSelectedIndex: Int = 0

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
                                DayForecastView(dailyForecast: dailyForecast, timezoneOffset: forecastModel.forecast.timezoneOffset)
                                    .frame(width: UIScreen.main.bounds.width / 4.5)
                                    .background(forecastModel.day == index ? Color(UIColor.navbarBackground()) : Color(UIColor.backgroundPrimary()))
                                    .overlay(forecastModel.day == index ? RoundedRectangle(cornerRadius: 8).stroke(.white, lineWidth: 1) : nil)
                                    .onTapGesture() {
                                        forecastModel.day = index
                                    }
                             }
                        }
                    }
                    .background(Color(UIColor.backgroundPrimary()))

                    DaySummaryView(forecastModel: forecastModel)
                        .padding([.top, .bottom])

                    SlidingSelectorView(selectedIndex: $slidingSelectedIndex, titles: SelectorState.titles)
                        .padding(16)
                        .background(Color(UIColor.backgroundPrimary()))
                        .clipShape(.rect( topLeadingRadius: 12, topTrailingRadius: 12))
                        .padding([.leading, .trailing], 8)

                    ScrollView(.horizontal, showsIndicators: false) {
                        ScrollViewReader { pageScroller in
                            VStack(spacing: 8) {
                                HStack(alignment: .top, spacing: 0) {
                                    let timezoneOffset = forecastModel.forecast.timezoneOffset
                                    
                                    ForEach(forecastModel.forecast.hourly, id: \.id) { hourlyForecast in
                                        let size = CGSize(width: (UIScreen.main.bounds.width - 16) / 6, height: HourForecastView.preferredHeight)
                                        let isFirstForecast = forecastModel.forecast.hourly.first?.id == hourlyForecast.id
                                        let isLastForecast = forecastModel.forecast.hourly.last?.id == hourlyForecast.id
                                        
                                        if hourlyForecast.isFirstForecastOfDay && !isFirstForecast {
                                            HourForecastSeparatorView(day: hourlyForecast.date.shortDayOfWeek(timezoneOffset) ?? "-")
                                                .frame(width: size.width, height: size.height)
                                        }
                                        
                                        HourForecastView(hourlyForecast: hourlyForecast, timezoneOffset: timezoneOffset,
                                                         selectorState: SelectorState(rawValue: slidingSelectedIndex) ?? .precipitation)
                                        .frame(width: size.width, height:  size.height)
                                        .padding(.trailing, isLastForecast ? 28 : 0)
                                    }
                                    .onChange(of: forecastModel.day) { day in
                                        withAnimation {
                                            let dayDate = forecastModel.forecast.daily[day].date
                                            var calendar = Calendar.current
                                            calendar.timeZone = TimeZone(secondsFromGMT: forecastModel.forecast.timezoneOffset)!
                                        
                                            if let hourly: HourlyForecast = forecastModel.forecast.hourly.first(where: { calendar.isDate(dayDate, inSameDayAs: $0.date) }) {
                                                pageScroller.scrollTo(hourly.id, anchor: .leading)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding([.top, .bottom], 8)
                    .background(Color(UIColor.backgroundPrimary()))
                    .clipShape(.rect( bottomLeadingRadius: 12, bottomTrailingRadius: 12))
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
                                // TBD
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
    
    enum SelectorState: Int, CaseIterable {
        case precipitation
        case feelsLike
        
        var title: String {
            switch self {
            case .precipitation: return "Precipitation"
            case .feelsLike: return "Feels like°"
            }
        }
        
        static var titles: [String] {
            var titles: [String] = []
            for state in SelectorState.allCases {
                titles.append(state.title)
            }
            return titles
        }
    }
}

struct FullForecastView_Previews: PreviewProvider {
    static let location = Location(coordinates: CLLocationCoordinate2D(latitude: 41.8933203, longitude: 12.4829321), name: "Rome (Lazio)")
    static var forecast: Forecast = try! MockAPIService().getForecast(for: location.coordinates, from: [location])
    
    static var previews: some View {
        FullForecastView(forecastModel: ForecastModel(location: location, forecast: forecast, day: 5))
        .preferredColorScheme(.dark)
   }
}
