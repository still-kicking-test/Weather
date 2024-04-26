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
    @EnvironmentObject var appState: AppState

    let forecast: Forecast

    @State private var dailyScrollIndex: Int?
    @State private var hourlyScrollIndex: Int?
    
    @State private var selectorState: SelectorState = .precipitation
    @State private var slidingSelectedIndex: Int = 0

    @State private var isScrollLeftButtonEnabled: Bool = true
    @State private var isScrollRightButtonEnabled: Bool = true

    private let numHourlyForecastsPerScreen = 6

    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: forecast.timezoneOffset)!
        return calendar
    }

    var body: some View {
        
        NavigationStack() {
            ZStack {
                Color.navbarBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    Divider()
                        .background(Color.backgroundPrimary)
                    
                    Text(forecast.location?.fullName ?? "-")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.largeFontBold)
                        .padding([.bottom, .leading, .trailing])
                        .background(Color.backgroundPrimary)
                        .transaction { transaction in transaction.animation = nil }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(alignment: .top, spacing: 0) { // lazy so we can scroll to hidden elements (on the RHS) durinbg onAppear
                            ForEach(Array(forecast.daily.enumerated()), id: \.offset) { index, dailyForecast in
                                DayForecastView(dailyForecast: dailyForecast, timezoneOffset: forecast.timezoneOffset)
                                    .frame(width: UIScreen.main.bounds.width / 4.6)
                                    .background(appState.selectedDay == index ? Color.navbarBackground : Color.backgroundPrimary)
                                    .overlay(appState.selectedDay == index ? RoundedRectangle(cornerRadius: 8).stroke(.white, lineWidth: 1) : nil)
                                    .onTapGesture() {
                                        appState.selectedDay = index
                                        hourlyScrollIndex = hourlyScrollIndex(for: appState.selectedDay, in: forecast)
                                    }
                            }
                        }
                        .frame(height: DayForecastView.preferredHeight)
                        .padding(.bottom, 8)
                        .scrollTargetLayout()
                    }
                    .scrollPosition(id: $dailyScrollIndex, anchor: .center)
                    .background(Color.backgroundPrimary)
 
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {

                            DaySummaryView(forecast: forecast, selectedDay: appState.selectedDay)
                                .padding([.top, .bottom])
                                .transaction { transaction in transaction.animation = nil }

                            SlidingSelectorView(selectedIndex: $slidingSelectedIndex, titles: SelectorState.titles)
                                .padding(16)
                                .background(Color.backgroundPrimary)
                                .clipShape(.rect( topLeadingRadius: RoundedCorners.defaultRadius,
                                                  topTrailingRadius: RoundedCorners.defaultRadius))
                                .padding([.leading, .trailing], 8)
                                .onChange(of: slidingSelectedIndex) { oldValue, newValue in
                                    selectorState = SelectorState(rawValue: newValue) ?? .precipitation
                                }
                            
                            ZStack() {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    VStack(spacing: 0) {
                                        HourlyForecastsView(forecast: forecast, contentType: .multiple(selectorState), numForecastsPerScreen: numHourlyForecastsPerScreen)
                                    
                                        Rectangle() // make room for the non-scrolling overlay
                                            .frame(height: FullForecastOverlayView.height)
                                    
                                        HourlyForecastsView(forecast: forecast, contentType: .wind, numForecastsPerScreen: numHourlyForecastsPerScreen)
                                            .scrollTargetLayout()
                                    }
                                }

                                FullForecastOverlayView(isScrollLeftButtonEnabled: $isScrollLeftButtonEnabled,
                                                        isScrollRightButtonEnabled: $isScrollRightButtonEnabled,
                                                        scrollLeftButtonTapped: { scrollLeftTapped() },
                                                        scrollRightButtonTapped: { scrollRightTapped() })
                                    .frame(height: FullForecastOverlayView.height)
                                    .background(Color.navbarBackground)
                                    .offset(y: ((HourForecastMultipleView.preferredHeight - HourForecastWindView.preferredHeight) / 2))
                            }
                            .background(Color.backgroundPrimary)
                            .padding([.leading, .trailing], 8)
                            .scrollPosition(id: $hourlyScrollIndex)
                            .onChange(of: hourlyScrollIndex) { oldValue, newValue in
                                if let newValue = newValue,
                                   let index = dailyScrollIndex(for: newValue, in: forecast) {
                                    appState.selectedDay = index
                                    isScrollLeftButtonEnabled = newValue > 0
                                    isScrollRightButtonEnabled = HourlyForecastsView.indexForScrollRight(from: newValue,
                                                                                                         in: forecast.hourly,
                                                                                                         itemCount: numHourlyForecastsPerScreen) < forecast.hourly.count - 1
                                    withAnimation { dailyScrollIndex = index }
                                }
                            }

                            ScrollButtonsView (isScrollLeftButtonEnabled: $isScrollLeftButtonEnabled,
                                               isScrollRightButtonEnabled: $isScrollRightButtonEnabled,
                                               scrollLeftButtonTapped: { scrollLeftTapped() },
                                               scrollRightButtonTapped: { scrollRightTapped() })
                            .padding([.top, .bottom], 8)
                            .background(Color.backgroundPrimary)
                            .clipShape(.rect( bottomLeadingRadius: RoundedCorners.defaultRadius,
                                              bottomTrailingRadius: RoundedCorners.defaultRadius))
                            .padding([.leading, .trailing], 8)

                            SunriseSunsetView(forecast: forecast, selectedDay: appState.selectedDay)
                                .padding(16)
                                .background(Color.backgroundPrimary)
                                .cornerRadius(RoundedCorners.defaultRadius)
                                .padding([.leading, .trailing], 8)
                                .padding([.top], 24)
                        }
                    }
                }
                .foregroundColor(.defaultText)
                .font(.defaultFont)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbarBackground(.hidden, for: .navigationBar)
                .toolbar {
                    Group {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Close", role: .cancel) { dismiss() }
                                .buttonStyle(PrimaryButtonStyle())
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            ShareLink(item: "\(forecast.sharedSummary(for: appState.selectedDay))") {
                                Image(systemName: "square.and.arrow.up")
                            }
                            .buttonStyle(PrimaryButtonStyle())
                        }
                    }
                }
                .onAppear() {
                    hourlyScrollIndex = hourlyScrollIndex(for: appState.selectedDay, in: forecast)
                }
            }
        }
    }
    
    private func scrollLeftTapped() {
        withAnimation { hourlyScrollIndex = HourlyForecastsView.indexForScrollLeft(from: hourlyScrollIndex,
                                                                                   in: forecast.hourly,
                                                                                   itemCount: numHourlyForecastsPerScreen) }
    }

    private func scrollRightTapped() {
        withAnimation { hourlyScrollIndex = HourlyForecastsView.indexForScrollRight(from: hourlyScrollIndex,
                                                                                    in: forecast.hourly,
                                                                                    itemCount: numHourlyForecastsPerScreen) }
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
    
    func hourlyScrollIndex(for day: Int, in forecast: Forecast) -> Int? {
        forecast.hourly.firstIndex(where: { calendar.isDate(forecast.daily[day].date, inSameDayAs: $0.date) })
    }

    func dailyScrollIndex(for hour: Int, in forecast: Forecast) -> Int? {
        forecast.daily.firstIndex(where: { calendar.isDate(forecast.hourly[hour].date, inSameDayAs: $0.date) })
    }
}

extension Forecast {
    func sharedSummary(for day: Int) -> String {
        guard let dailyForecast = daily[safe: day],
              let date = dailyForecast.date.dayOfWeek(timezoneOffset, dayFormat: "EEEE"),
              let location = location?.fullName else { return "No data" }
        
        return "Weather forecast for \(location) from the Weather App. \(date): \(dailyForecast.summary.lowercaseFirstChar)"
    }
}

struct FullForecastView_Previews: PreviewProvider {
    static let appState = AppState()
    static let location = Location(coordinates: CLLocationCoordinate2D(latitude: 41.8933203, longitude: 12.4829321), name: "Rome (Lazio)")
    static var forecast: Forecast = try! MockAPIService().getForecast(for: location.coordinates, from: [location])
    
    static var previews: some View {
        FullForecastView(forecast: forecast)
        .preferredColorScheme(.dark)
        .environmentObject(appState)
   }
}
