//
//  DateTests.swift
//  WeatherTests
//
//  Created by jonathan saville on 31/08/2023.
//

import XCTest
@testable import Weather

final class DateTests: XCTestCase {

    func testTemperatureString() {
        continueAfterFailure = false
        XCTAssertEqual(Decimal(2.49998).temperatureString, "2°")
        XCTAssertEqual(Decimal(10.50003).temperatureString, "11°")
        XCTAssertEqual(Decimal(0).temperatureString, "0°")
        XCTAssertEqual(Decimal(0.3).temperatureString, "0°")
        XCTAssertEqual(Decimal(0.7).temperatureString, "1°")
        XCTAssertEqual(Decimal(-0.9).temperatureString, "-1°")
    }
}
