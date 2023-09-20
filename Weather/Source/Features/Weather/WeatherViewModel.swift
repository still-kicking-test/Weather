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
    @Published var generalError: Error? = nil

    private let apiService: APIServiceProtocol
    private let coreDataManager: CoreDataManager
    private var cancellables = Set<AnyCancellable>()

    init(apiService: APIServiceProtocol = APIService.shared,
         coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.apiService = apiService
        self.coreDataManager = coreDataManager
    }

    public var forecastCount: Int { forecast.count }
    
    public func forecast(forIndex index: Int) -> Forecast? {
        guard forecast.indices.contains(index) else { return nil }
        return forecast[index]
    }
    
    func loadForecasts() {
        
        apiService.getForecasts(locations: coreDataManager.locations)
            .sink{
                switch $0 {
                    case .failure(let error): self.generalError = error
                    case .success(let value): self.forecast = value
                 }
            }
            .store(in: &cancellables)
    }
}
