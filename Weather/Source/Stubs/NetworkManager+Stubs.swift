//
//  NetworkManager+Stubs.swift
//  Weather
//
//  Created by jonathan saville on 22/03/2024.
//

extension NetworkManager {

    class Stub: NetworkManagerProtocol {
        func loadForecasts() async { }
    }
    
    public static var stub: NetworkManagerProtocol {
        NetworkManager.Stub()
    }
}
