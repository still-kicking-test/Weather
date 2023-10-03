//
//  WeatherViewModel.swift
//  Weather
//
//  Created by jonathan saville on 31/08/2023.
//
import Foundation
import Combine

class WeatherViewModel {
        
    @Published var forecast: [Forecast] = []
    @Published var isLoading: Bool = false
    @Published var generalError: Error? = nil

    private let apiService: APIServiceProtocol
    private let coreDataManager: CoreDataManager
    private var cancellables = Set<AnyCancellable>()

    init(apiService: APIServiceProtocol = APIService.shared,
         coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.apiService = apiService
        self.coreDataManager = coreDataManager
        observeCoreData()
    }

    public var forecastCount: Int { forecast.count }
    
    public func forecast(forIndex index: Int) -> Forecast? {
        guard forecast.indices.contains(index) else { return nil }
        return forecast[index]
    }
    
    @objc
    func loadForecasts() {
        isLoading = true
        let delay: CGFloat = 0.5 // set to non-zero for dev testing, then reset to 0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.apiService.getForecasts(locations: self.coreDataManager.locations)
                .sink{
                    self.isLoading = false
                    switch $0 {
                    case .failure(let error): self.generalError = error
                    case .success(let value): self.forecast = value
                    }
                }
                .store(in: &self.cancellables)
        }
    }

    private func observeCoreData() {
        // A simple observation of a Notification triggered when the CoreData is saved. This only happens
        // when the locations are changed, and because that potentially has resulted in the order changing,
        // we simply refresh the whol screen with an API call. Nice and clean...
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadForecasts),
                                               name: .coreDataSaved,
                                               object: nil)
    }
}
