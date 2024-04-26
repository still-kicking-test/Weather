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
    
    public enum UserDefaultsKeys {
        static let showVideo = "showVideo"
        static let showCurrentLocation = "showCurrentLocation"
    }
    
    enum State {
        case idle
        case loading
        case error(Error)
        case loaded([Forecast], isReloadRequired: Bool)
        
        fileprivate mutating func setReloadRequired() {
            switch self {
            case let .loaded(forecasts, false):
                self = .loaded(forecasts, isReloadRequired: true)
            default: break
            }
        }
    }
    
    @Published var state: State = .idle
    @Published var locationManagerAuthorized: Bool = false
    @Published var showCurrentLocation: Bool = UserDefaults.standard.object(forKey: UserDefaultsKeys.showCurrentLocation) as? Bool ?? false
    @Published var showVideo: Bool = UserDefaults.standard.object(forKey: UserDefaultsKeys.showVideo) as? Bool ?? false
    @Published var locations: [CDLocation] = CoreDataManager.shared.locations
    var selectedDay: Int = 0

    func changeState(to newState: State) {
        DispatchQueue.main.async {
            self.state = newState
        }
    }
    
    func setReloadRequired() {
        state.setReloadRequired()
    }
}
