//
//  APIService.swift
//  Weather
//
//  Created by jonathan saville on 04/09/2023.
//

import Foundation
import Combine

protocol APIServiceProtocol {
    func get<T: Decodable>(endpoint: Endpoint<T>) -> AnyPublisher<T, Error>
    func getArray<T: Decodable>(endpoint: Endpoint<T>) -> AnyPublisher<[T], Never>
}

enum APIError: LocalizedError {
    case badURL
    case networkError(Error)
    case invalidResponse
    case clientError(String)
    case serverError(String)
    case jsonError(Error)
    case unexpected(String)
    
    var errorDescription: String? {
        switch self {
        case .badURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response received"
        case .clientError(let message):
            return "Client Error: \(message)"
        case .serverError(let message):
            return "Server Error: \(message)"
        case .jsonError:
            return "Unexpected data received from server"
        case .unexpected(let message):
            return "Received unexpected error: \(message)"
        }
    }
}

private struct APIErrorMessage: Decodable {
  var error: Bool
  var reason: String
}

class APIService: APIServiceProtocol {
    
    public static let shared = APIService()
    private let urlSession = URLSession.shared

    public func get<T: Decodable>(endpoint: Endpoint<T>) -> AnyPublisher<T, Error> {
        
        guard let request = endpoint.request else {
            return Fail(error: APIError.badURL).eraseToAnyPublisher()
        }

        return urlSession.dataTaskPublisher(for: request)
            .mapError { error -> Error in return APIError.networkError(error) }
            .tryMap { (data, response) -> (data: Data, response: URLResponse) in
               guard let urlResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse }
               
               if (200..<300) ~= urlResponse.statusCode {
               }
               else {
                   let apiError = try JSONDecoder().decode(APIErrorMessage.self, from: data)
                   switch urlResponse.statusCode {
                   case 300..<400: throw APIError.unexpected(apiError.reason)
                   case 400..<500: throw APIError.clientError(apiError.reason)
                   case 500..<600: throw APIError.serverError(apiError.reason)
                   default: throw APIError.invalidResponse
                   }
               }
               return (data, response)
             }
            .map(\.data)
            .tryMap { data -> T in
              do { return try JSONDecoder().decode(T.self, from: data) }
              catch { throw APIError.jsonError(error) }
            }
            .eraseToAnyPublisher()
    }
    
    // No error handling - returns an empty array
    public func getArray<T: Decodable>(endpoint: Endpoint<T>) -> AnyPublisher<[T], Never> {
        guard let request = endpoint.request else {
            return Just([T].init()).eraseToAnyPublisher()
        }

        return urlSession.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .map { datum -> [T] in [T].init(arrayLiteral: datum) }
            .catch{ (error) -> AnyPublisher<[T], Never> in
                print("\(error)")
                return Just([T].init()).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
