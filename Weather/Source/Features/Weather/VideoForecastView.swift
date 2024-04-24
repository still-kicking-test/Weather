//
//  VideoForecastView.swift
//  Weather
//
//  Created by jonathan saville on 10/11/2023.
//

import SwiftUI
import CoreLocation
import WeatherNetworkingKit

struct VideoForecastView: View {
    let title: String
    let urlString: String
    
    init(title: String = "UK video forecast",
         urlString: String = "https://www.youtube.com/embed/UxFyCqJoOpE?playsinline=1") {
        self.title = title
        self.urlString = urlString
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text(title)
                .font(.largeFontBold)
                .padding(.top, 16)
                .padding(.leading, 12)
            
            if let url = URL(string: urlString) {
                WebView(url: url)
                    .aspectRatio(16/9, contentMode: .fit)
                    .padding([.bottom, .leading, .trailing], 16)
            }
        }
    }
}

struct VideoForecastView_Previews: PreviewProvider {

    static var previews: some View {
        VideoForecastView()
            .preferredColorScheme(.dark)
            .background(.gray)
    }
}
