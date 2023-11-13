//
//  HourForecastSeparatorView.swift
//  Weather
//
//  Created by jonathan saville on 09/10/2023.
//

import SwiftUI
import CoreLocation
import UIKit
import WeatherNetworkingKit

struct HourForecastSeparatorView: View {
    var day: String

    var body: some View {
        VStack(spacing: 8) {

            DottedLine()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                .frame(width: 1)
                .foregroundColor(Color(UIColor.divider()))
            
            Text(day)
                .font(Font(UIFont.defaultFontBold))
        }
    }
}

struct HourForecastSeparatorView_Previews: PreviewProvider {
    static var previews: some View {
        HourForecastSeparatorView(day: "Mon")
            .preferredColorScheme(.dark)
    }
}
