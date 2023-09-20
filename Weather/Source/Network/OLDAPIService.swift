//
//  APIService.swift
//  Weather
//
//  Created by jonathan saville on 04/09/2023.
//
/*
import Foundation
import Combine

class APIService {
    
    static let shared = APIService()
    static let apiKey = "5188f5c9af2c5d545d8640c21b6f5f60"
    static let testURL = URL(string: "https://api.openweathermap.org/data/3.0/onecall?units=metric&lat=52.616&lon=0.54&appid=5188f5c9af2c5d545d8640c21b6f5f60")!
    
    func getRequest<T: Codable>(url: URL, type: T.Type, completionHandler: @escaping (T) -> Void, errorHandler: @escaping (String) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error as Any)
                errorHandler(error?.localizedDescription ?? "Error!")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("status code is not 200")
                errorHandler("Status code is not 200")
                print(response as Any)
            }
            // print("data received: \(String(decoding: data, as: UTF8.self))")
            if let mappedResponse = try? JSONDecoder().decode(T.self, from: data) {
                completionHandler(mappedResponse)
            }
        }
        
        task.resume()
    }
  
    func asyncGetRequest<T: Codable>(url: URL, type: T.Type) async throws -> T? {
        
        let request = URLRequest(url: url)
        
        //run the request and retrieve both the data and the response of the call
        let (data, response) = try await URLSession.shared.data(for: request)
        
        //checks if there are errors regarding the HTTP status code and decodes using the passed struct
        let mappedResponse = try? JSONDecoder().decode(T.self, from: data)
        
        return mappedResponse
    }
    

    func postRequest<T: Codable>(url: URL, params: [String: Any], type: T.Type, completionHandler: @escaping (T) -> Void, errorHandler: @escaping (String) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        let task = URLSession.shared.uploadTask(with: request, from: jsonData) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error as Any)
                errorHandler(error?.localizedDescription ?? "Error!")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("status code is not 200")
                errorHandler("Status code is not 200")
                print(response as Any)
            }
            
            if let mappedResponse = try? JSONDecoder().decode(T.self, from: data) {
                completionHandler(mappedResponse)
            }
        }
        
        task.resume()
    }
    
}

struct OneCall: Codable, Identifiable {
    var id: UUID?
    var lat: Double
    var lon: Double
    var timezone: String
    var current: Current?
    var daily: [Daily]
    
    init() {
        lat = 0
        lon = 0
        timezone = ""
        daily = []
    }
}

struct Current: Codable, Identifiable {
    var id: UUID?
    var dt: Double
    var sunrise: Double
    var sunset: Double
    var pressure: Int
    var humidity: Int
    var wind_deg: Int
    var wind_speed: Double
    var weather: [Weather]
    var temp: Double
}

struct Daily: Codable, Identifiable {
    var id: UUID?
    var dt: Double
    var sunrise: Double
    var sunset: Double
    var pressure: Int
    var humidity: Int
    var wind_deg: Int
    var wind_speed: Double
    var weather: [Weather]
    
    var wind_gust: Double
    var temp: DailyTemp
}

struct DailyTemp: Codable {
    var day: Double
    var min: Double
    var max: Double
    var night: Double
    var eve: Double
    var morn: Double
}

struct Weather: Codable {
        var id: Int
        var main: String
        var description: String
        var icon: String
}

enum APIError : Error {
    // Can't connect to the server (maybe offline?)
    case ConnectionError(error: NSError)
    // The server responded with a non 200 status code
    case ServerError(statusCode: Int, error: NSError)
    // We got no data (0 bytes) back from the server
    case NoDataError
    // The server response can't be converted from JSON to a Dictionary
    case JSONSerializationError(error: Error)
    // The Argo decoding Failed
    case JSONMappingError(converstionError: Error)
}

extension APIService {
 
    func getOneCall() {
        //getRequest<T: Codable>(url: URL, type: T.Type, completionHandler: @escaping (T) -> Void, errorHandler: @escaping (String) -> Void) {
        
        getRequest(url: Self.testURL, type: OneCall.self, completionHandler: {ok in print("ok: \(String(describing: ok))")}, errorHandler: {error in print("error: \(String(describing: error))")})
    }
    
    func asyncGetOneCall() {
        Task {
             do{
                 let oneCall = try await asyncGetRequest(url: Self.testURL, type: OneCall.self)
                 print("in task, oneCall: \(oneCall)")
             } catch {
                  print(error)
                  //handle the error
             }
        }
        //getRequest<T: Codable>(url: URL, type: T.Type, completionHandler: @escaping (T) -> Void, errorHandler: @escaping (String) -> Void) {
    }
}
*/
