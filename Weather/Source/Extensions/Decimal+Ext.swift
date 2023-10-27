//
//  Decimal+Ext.swift
//  Weather
//
//  Created by jonathan saville on 16/09/2023.
//

import Foundation

extension Decimal {
    
    mutating func round(_ scale: Int, _ roundingMode: NSDecimalNumber.RoundingMode) {
        var localCopy = self
        NSDecimalRound(&self, &localCopy, scale, roundingMode)
    }

    func rounded(_ scale: Int = 0, _ roundingMode: NSDecimalNumber.RoundingMode = .plain) -> Decimal {
        var result = Decimal()
        var localCopy = self
        NSDecimalRound(&result, &localCopy, scale, roundingMode)
        return result
    }

    var temperatureString: String {
        "\(rounded())°"
    }

    var precipitationString: String {
        guard self <= 1 else { return "-" }
        guard self <= 0.95 else { return "95%" }
        guard self > 0.05 else { return "<5%" }

        let percentageRoundedTo5 = (self * 100 / 5).rounded() * 5
        return "\(percentageRoundedTo5)%"
    }

    var beaufort: Beaufort { Beaufort.fromSpeed(self) }
}
