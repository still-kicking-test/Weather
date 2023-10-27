//
//  DecimalTests.swift
//  WeatherTests
//
//  Created by jonathan saville on 26/10/2023.
//

import XCTest
@testable import Weather

final class DecimalTests: XCTestCase {
    
    func testTemperatureString() {
        continueAfterFailure = false
        XCTAssertEqual(Decimal(2.49998).temperatureString, "2°")
        XCTAssertEqual(Decimal(10.50003).temperatureString, "11°")
        XCTAssertEqual(Decimal(0).temperatureString, "0°")
        XCTAssertEqual(Decimal(0.3).temperatureString, "0°")
        XCTAssertEqual(Decimal(0.7).temperatureString, "1°")
        XCTAssertEqual(Decimal(-0.9).temperatureString, "-1°")
    }
    
    func testPrecipitationString() {
        continueAfterFailure = false
        XCTAssertEqual(Decimal(1.1).precipitationString, "-")
        XCTAssertEqual(Decimal(0.02).precipitationString, "<5%")
        XCTAssertEqual(Decimal(0.9).precipitationString, "90%")
        XCTAssertEqual(Decimal(0.9000).precipitationString, "90%")
        XCTAssertEqual(Decimal(0.30).precipitationString, "30%")
        XCTAssertEqual(Decimal(0.31).precipitationString, "30%")
        XCTAssertEqual(Decimal(0.32).precipitationString, "30%")
        XCTAssertEqual(Decimal(0.33).precipitationString, "35%")
        XCTAssertEqual(Decimal(0.34).precipitationString, "35%")
        XCTAssertEqual(Decimal(0.36).precipitationString, "35%")
        XCTAssertEqual(Decimal(0.37).precipitationString, "35%")
        XCTAssertEqual(Decimal(0.38).precipitationString, "40%")
        XCTAssertEqual(Decimal(0.39).precipitationString, "40%")
        XCTAssertEqual(Decimal(0.91).precipitationString, "90%")
        XCTAssertEqual(Decimal(0.99).precipitationString, "95%")
    }
}
