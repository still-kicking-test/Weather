//
//  WeatherView.swift
//  Weather
//
//  Created by jonathan saville on 14/03/2024.
//

import SwiftUI
import WeatherNetworkingKit

struct WeatherView: View {

    @EnvironmentObject var appState: AppState
    @Environment(\.injected) private var injected: InteractorContainer

    @State private var showSettingsView = false
    @State private var showEditView = false
    @State private var showFullForecast: Forecast?

    var body: some View {

        NavigationStack {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [.backgroundGradientFrom,
                                                           .backgroundGradientTo]), startPoint: .bottom, endPoint: .top)
                
                switch appState.state {

                case .idle:
                    EmptyView()

                case .loading:
                    ActivityIndicator()
                        .frame(width: 44, height: 44)
                        .background(.clear)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                case .loaded(let forecasts):

                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 16) {
                            if forecasts.isEmpty {
                                if appState.showVideo {
                                    VideoForecastView()
                                        .forecastItem()
                                } else {
                                    Text(CommonStrings.noForecastItems) // TBD - make more user-friendly
                                        .foregroundColor(.defaultText)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 300)
                                        .padding(.top, 100)
                                }
                            } else {
                                ForEach(Array(forecasts.enumerated()), id: \.offset) { index, forecast in
                                    SummaryForecastView(forecast: forecast, showFullForecast: $showFullForecast)
                                        .forecastItem()
                                    
                                    if appState.showVideo && index == 0 { // video is always the second item (or the first if the only one)
                                        VideoForecastView()
                                            .forecastItem()
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 16)
                    }
                    .padding(0)
                    .padding(.top, 8)

                case .error(let error):
                    Text(String(describing: error)) // TBD - make more user-friendly
                        .foregroundColor(.defaultText)
                }
            }
            .sheet(item: $showFullForecast, content: { forecast in FullForecastView(forecast: forecast) })
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.navbarBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { showSettingsView = true } label: { Image(systemName: "gearshape") }
                        .buttonStyle(PrimaryButtonStyle())
                        .sheet(isPresented: $showSettingsView) { SettingsView() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showEditView = true } label: { Text("Edit") }
                        .buttonStyle(PrimaryButtonStyle())
                    .fullScreenCover(isPresented: $showEditView) { LocationsWrapperView() }
                        .transaction({ transaction in transaction.disablesAnimations = true })
                }
                ToolbarItem(placement: .principal) {
                    Text("Weather").font(.largeFont)
                        .foregroundColor(.defaultText)
                }
            }
        }
        .onAppear {
            guard case .idle = appState.state else { return }
            injected.interactors.weatherInteractor.loadForecasts()
        }
    }
}

private extension View {
    func forecastItem() -> some View {
        self.modifier( ForecastItemModifier() )
     }
}

private struct ForecastItemModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.backgroundPrimary)
            .foregroundColor(.defaultText)
            .cornerRadius(RoundedCorners.defaultRadius)
            .padding([.leading, .trailing], 8)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static let appEnvironment = AppEnvironment.mocked()

    static var previews: some View {
        WeatherView()
            .environmentObject(appEnvironment.appState)
            .environment(\.injected, appEnvironment.container)
   }
}
