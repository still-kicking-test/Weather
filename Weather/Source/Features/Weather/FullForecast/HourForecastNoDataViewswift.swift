//
//  HourForecastNoDataView.swift
//  Weather
//
//  Created by jonathan saville on 09/10/2023.
//

import SwiftUI
import CoreLocation
import UIKit
import WeatherNetworkingKit

struct HourForecastNoDataView: View {

    var body: some View {
        VStack(spacing: HourForecastView.verticalSpacing) {

            DottedLine()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                .frame(width: 1)
                .foregroundColor(Color(UIColor.divider()))
            
            Text(day)
                .font(Font(UIFont.defaultFontBold))
                .padding(.bottom, HourForecastView.verticalSpacing)
        }
    }
}

struct HourForecastNoDataView_Previews: PreviewProvider {
    static var previews: some View {
        HourForecastNoDataView()
            .preferredColorScheme(.dark)
    }
}
