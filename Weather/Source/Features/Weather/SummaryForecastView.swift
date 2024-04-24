//
//  SummaryForecastView.swift
//  Weather
//
//  Created by jonathan saville on 10/11/2023.
//

import SwiftUI
import CoreLocation
import WeatherNetworkingKit

struct SummaryForecastView: View {
    @EnvironmentObject var appState: AppState
    var forecast: Forecast
    @Binding var showFullForecast: Forecast?

    @State private var scrollIndex: Int?
    @State private var isScrollLeftButtonEnabled: Bool = false
    @State private var isScrollRightButtonEnabled: Bool = false

    private let numForecastsPerScreen = 5

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text(forecast.location?.fullName ?? "<unknown>")
                .font(.largeFontBold)
                .padding(.top, 16)
                .padding(.leading, 12)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(Array(forecast.daily.enumerated()), id: \.offset) { index, dailyForecast in
                        VStack(spacing: 8) {
                            // day
                            Text(dailyForecast.date.dayOfWeek(forecast.timezoneOffset) ?? "-")
                                .font(.largeFont)
                                .padding(.bottom, 8)
                            
                            // icon
                            AsyncImage(url: ImageLoader.iconURL(for: dailyForecast.displayable.first?.icon ?? "")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: { /* loadingView */ }
                                .frame(height: 40)
                                .padding(.bottom, 0)
                            
                            // max temperature
                            Text(dailyForecast.temperature.max.temperatureString)
                                .font(.largeFont)
                                .padding(.bottom, 4)
                            
                            // min temperature
                            Text(dailyForecast.temperature.min.temperatureString)
                                .font(.defaultFont)
                                .padding(.bottom, 4)
                        }
                        .foregroundColor(.defaultText)
                        .frame(width: (UIScreen.main.bounds.width - 16) / 5)
                        .background(Color.backgroundPrimary)
                        .onTapGesture { appState.selectedDay = index; showFullForecast = forecast }
                    }
                }
            }
            .scrollTargetLayout()
            .scrollPosition(id: $scrollIndex)
            .onChange(of: scrollIndex) { oldValue, newValue in
                if let newValue = newValue {
                    isScrollLeftButtonEnabled = newValue > 0
                    isScrollRightButtonEnabled = (scrollIndex ?? 0) + numForecastsPerScreen < forecast.daily.count
                }
            }

            HStack {
                Button { appState.selectedDay = 0; showFullForecast = forecast } label: { Text("View full forecast") }
                    .font(.defaultFont)
                    .padding(.bottom, 16)
                    .padding(.leading, 12)
                    .buttonStyle(PrimaryButtonStyle())

                Spacer()

                ScrollButtonsView(isScrollLeftButtonEnabled: $isScrollLeftButtonEnabled,
                                  isScrollRightButtonEnabled: $isScrollRightButtonEnabled,
                                  scrollLeftButtonTapped: { scrollLeftTapped() },
                                  scrollRightButtonTapped: { scrollRightTapped() })
                    .frame(height: 24)
                    .offset(y: -8)
            }
            .background(Color.backgroundPrimary)
        }
        .onAppear {
            scrollIndex = 0 // triggers the onChange to set scroll button visibility
        }
    }

    private func scrollLeftTapped() {
        withAnimation { scrollIndex = max(0, (scrollIndex ?? 0) - numForecastsPerScreen) }
    }

    private func scrollRightTapped() {
        withAnimation { scrollIndex = min(forecast.daily.count - numForecastsPerScreen, (scrollIndex ?? 0) + numForecastsPerScreen) }
    }
}

struct SummaryForecastView_Previews: PreviewProvider {
    static let location = Location(coordinates: CLLocationCoordinate2D(latitude: 41.8933203, longitude: 12.4829321), name: "Rome (Lazio)")
    static let forecast: Forecast = try! MockAPIService().getForecast(for: location.coordinates, from: [location])
    @State static private var showFullForecast: Forecast?

    static var previews: some View {
        SummaryForecastView(forecast: forecast, showFullForecast: $showFullForecast)
            .preferredColorScheme(.dark)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .background(.gray)
    }
}
