//
//  AppState.swift
//  Weather
//
//  Created by jonathan saville on 18/03/2024.
//

import Combine
import WeatherNetworkingKit
import CoreData

public class AppState: ObservableObject {
    
    private enum UserDefaultsKeys {
        static let showVideo = "showVideo"
        static let showCurrentLocation = "showCurrentLocation"
    }

    private var userDefaults = UserDefaults.standard
    private var cancellables = Set<AnyCancellable>()

    enum State {
        case idle
        case loading
        case error(Error)
        case loaded([Forecast])
    }
    
    @Published var state: State = .idle
    @Published var locationManagerAuthorized: Bool = false
    @Published var showCurrentLocation: Bool = UserDefaults.standard.object(forKey: UserDefaultsKeys.showCurrentLocation) as? Bool ?? false
    @Published var showVideo: Bool = UserDefaults.standard.object(forKey: UserDefaultsKeys.showVideo) as? Bool ?? false
    var selectedDay: Int = 0
    var locations: [CDLocation] = []

    init() {
        bind()
    }

    func changeState(to newState: State) {
        DispatchQueue.main.async {
            self.state = newState
        }
    }

    private func bind() {
        $showVideo.sink { showVideo in
            self.userDefaults.set(showVideo, forKey: UserDefaultsKeys.showVideo)
        }.store(in: &cancellables)
        
        $showCurrentLocation.sink { showCurrentLocation in
            self.userDefaults.set(showCurrentLocation, forKey: UserDefaultsKeys.showCurrentLocation)
        }.store(in: &cancellables)
    }
}
