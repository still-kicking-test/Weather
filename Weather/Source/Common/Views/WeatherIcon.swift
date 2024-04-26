//
//  WeatherIcon.swift
//  Weather
//
//  Created by jonathan saville on 26/04/2024.
//

import SwiftUI
import WeatherNetworkingKit

struct WeatherIcon: View {

    let image: Image

    static let systemIcons: [String: String] = [
        "01d": "sun.max.fill",
        "01n": "moon.fill",
        "02d": "cloud.sun.fill",
        "02n": "cloud.moon.fill",
        "03d": "cloud.fill",
        "03n": "cloud.fill",
        "04d": "smoke.fill",
        "04n": "smoke.fill",
        "09d": "cloud.rain.fill",
        "09n": "cloud.rain.fill",
        "10d": "cloud.sun.rain.fill",
        "10n": "cloud.moon.rain.fill",
        "11d": "cloud.bolt.fill",
        "11n": "cloud.bolt.fill",
        "13d": "snowflake",
        "13n": "snowflake"
    ]

    static let localIcons: [String: String] = [
        "50d": "mist",
        "50n": "mist"
    ]

    init(fromOpenWeatherCode code: String) {
        if let systemName = WeatherIcon.systemIcons[code] {
            image = Image(systemName: systemName)
        } else {
            image = Image(uiImage: UIImage(named: WeatherIcon.localIcons[code] ?? "") ?? UIImage())
        }
    }
    
    var body: some View {
        image.imageScale(.large)
             .symbolRenderingMode(.multicolor)
    }
}

struct WeatherIcon_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack(spacing: 0) {
            ForEach(Array(WeatherIcon.systemIcons.keys.enumerated()), id:\.element) { _, key in
                HStack() {
                    AsyncImage(url: ImageLoader.iconURL(for: key)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: { }
                        .frame(width: 40, height: 40)
                    
                    WeatherIcon(fromOpenWeatherCode: key)
                        .frame(width: 40, height: 40)
                }
            }
            
            ForEach(Array(WeatherIcon.localIcons.keys.enumerated()), id:\.element) { _, key in
                HStack() {
                    AsyncImage(url: ImageLoader.iconURL(for: key)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: { }
                        .frame(width: 40, height: 40)
                    
                    WeatherIcon(fromOpenWeatherCode: key)
                        .frame(width: 40, height: 40)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
