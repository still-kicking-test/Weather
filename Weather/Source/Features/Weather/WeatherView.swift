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

                case .idle, .loaded(_, true):
                    EmptyView()

                case .loading:
                    ActivityIndicator()
                        .frame(width: 44, height: 44)
                        .background(.clear)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                case .loaded(let forecasts, false):

                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 16) {
                            if forecasts.isEmpty {
                                if appState.showVideo {
                                    VideoForecastView()
                                        .displayAsCard()
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
                                        .displayAsCard()
                                    
                                    if appState.showVideo && index == 0 { // video is always the second item (or the first if the only one)
                                        VideoForecastView()
                                            .displayAsCard()
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
            .fullScreenCover(item: $showFullForecast, content: { forecast in FullForecastView(forecast: forecast) })
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.navbarBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { showSettingsView = true } label: { Image(systemName: "gearshape") }
                        .buttonStyle(PrimaryButtonStyle())
                        .sheet(isPresented: $showSettingsView) { SettingsView() }
                }
                ToolbarItem(placement: .principal) {
                    NavBarTitleView()
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button { showEditView = true } label: { Text("Edit") }
                        .buttonStyle(PrimaryButtonStyle())
                        .fullScreenCover(isPresented: $showEditView) { LocationsView().onDisappear { loadForecastsIfRequired() } }
                        .transaction({ transaction in transaction.disablesAnimations = true })
                }
            }
            .onAppear { loadForecastsIfRequired() }
            .refreshable {
                appState.setReloadRequired()
                loadForecastsIfRequired()
            }
        }
    }
    
    private func loadForecastsIfRequired() {
        switch appState.state {
        case .idle,
             .loaded(_, true):
            injected.interactors.weatherInteractor.loadForecasts()
        default: break
        }
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
