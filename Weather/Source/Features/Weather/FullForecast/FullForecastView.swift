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
    let forecast: Forecast
    @State var selectedDay: Int
    @State private var slidingSelectedIndex: Int = 0

    var body: some View {
        NavigationStack() {
            
            ZStack {
                Color(UIColor.navbarBackground()).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Divider()
                        .background(Color(UIColor.backgroundPrimary()))
                    
                    Text(forecast.location?.fullName ?? "-")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font(UIFont.largeFontBold))
                        .padding([.bottom, .leading, .trailing])
                        .background(Color(UIColor.backgroundPrimary()))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 0) {
                            ForEach(Array(forecast.daily.enumerated()), id: \.offset) { index, dailyForecast in
                                DayForecastView(dailyForecast: dailyForecast, timezoneOffset: forecast.timezoneOffset)
                                    .frame(width: UIScreen.main.bounds.width / 4.5)
                                    .background(selectedDay == index ? Color(UIColor.navbarBackground()) : Color(UIColor.backgroundPrimary()))
                                    .overlay(selectedDay == index ? RoundedRectangle(cornerRadius: 8).stroke(.white, lineWidth: 1) : nil)
                                    .onTapGesture() { selectedDay = index }
                            }
                        }
                    }
                    .background(Color(UIColor.backgroundPrimary()))
                    
                    DaySummaryView(forecast: forecast, selectedDay: selectedDay)
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
                                    let timezoneOffset = forecast.timezoneOffset
                                    
                                    ForEach(forecast.hourly, id: \.id) { hourlyForecast in
                                        let size = CGSize(width: (UIScreen.main.bounds.width - 16) / 6, height: HourForecastView.preferredHeight)
                                        let isFirstForecast = forecast.hourly.first?.id == hourlyForecast.id
                                        let isLastForecast = forecast.hourly.last?.id == hourlyForecast.id
                                        
                                        if hourlyForecast.isFirstForecastOfDay && !isFirstForecast {
                                            HourForecastSeparatorView(day: hourlyForecast.date.shortDayOfWeek(timezoneOffset) ?? "-")
                                                .frame(width: size.width, height: size.height)
                                        }
                                        
                                        HourForecastView(hourlyForecast: hourlyForecast, timezoneOffset: timezoneOffset,
                                                         selectorState: SelectorState(rawValue: slidingSelectedIndex) ?? .precipitation)
                                        .frame(width: size.width, height:  size.height)
                                        .padding(.trailing, isLastForecast ? 28 : 0)
                                    }
                                    .onChange(of: selectedDay) { day in scrollTo(day, in: forecast, withProxy: pageScroller) }
                                }
                            }
                            .onAppear() { scrollTo(selectedDay, in: forecast, withProxy: pageScroller) }
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
    
    func scrollTo(_ day: Int, in forecast: Forecast, withProxy scrollProxy: ScrollViewProxy) {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: forecast.timezoneOffset)!
        
        let firstHourlyForecast = forecast.hourly.first(where: { calendar.isDate(forecast.daily[day].date, inSameDayAs: $0.date) })
        if let id = firstHourlyForecast?.id {
            scrollProxy.scrollTo(id, anchor: .leading)
        }
    }
}

struct FullForecastView_Previews: PreviewProvider {
    static let location = Location(coordinates: CLLocationCoordinate2D(latitude: 41.8933203, longitude: 12.4829321), name: "Rome (Lazio)")
    static var forecast: Forecast = try! MockAPIService().getForecast(for: location.coordinates, from: [location])
    
    static var previews: some View {
        FullForecastView(forecast: forecast, selectedDay: 5)
        .preferredColorScheme(.dark)
   }
}
