//
//  MockAPIService.swift
//  Weather
//
//  Created by jonathan saville on 05/10/2023.
//

import Foundation
import Combine

class MockAPIService: APIServiceProtocol {

    public static let shared = MockAPIService()
    private init() {}
    
    func getLocations(query: String) -> AnyPublisher<Result<[LocationDataModel], Error>, Never> {
        let emptyResult: Result<[LocationDataModel], Error> = .success([])
        return Just(emptyResult).eraseToAnyPublisher()
    }

    func getForecasts(locations: [Location]) -> AnyPublisher<Result<[Forecast], Error>, Never> {
        guard locations.isEmpty == false else {
            let emptyResult: Result<[Forecast], Error> = .success([])
            return Just(emptyResult).eraseToAnyPublisher()
        }

        var forecasts: [Forecast] = []
        for location in locations {
            var dataModel: OneCallDataModel
            do {
                let filename = "OneCall(\(location.coordinates.latitude.rounded(3)),\(location.coordinates.longitude.rounded(3)))"
                dataModel = try decodeJSON(from: filename)
            }
            catch {
                let errorResult: Result<[Forecast], Error> = .failure(APIError.jsonError(error))
                return Just(errorResult).eraseToAnyPublisher()
            }
            var forecast = dataModel.toModel()
            forecast.loadLocation(with: (dataModel.lat, dataModel.lon), from: locations)
            forecast.resetDailyDates()
            forecasts.append(forecast)
        }

        let result: Result<[Forecast], Error> = .success(forecasts)
        return Just(result).eraseToAnyPublisher()
    }

    private func decodeJSON<T: Decodable>(from resource: String, type: String = "json", in bundle: Bundle = .main) throws -> T {
        let data: Data
        if let filepath = bundle.path(forResource: resource, ofType: type) {
            let json = try String(contentsOfFile: filepath)
            data = json.data(using: .utf8)!
         } else {
            throw (NSError(domain: "", code: 0))
        }
        return try JSONDecoder().decode(T.self, from: data)
   }
}

private extension Forecast {
    mutating func resetDailyDates() {
        let today = Date()
        for i in 0..<daily.count {
            let secondsInEachDay = 60 * 60 * 24
            daily[i].date = today.advanced(by: Double(i * secondsInEachDay))
        }
    }
}