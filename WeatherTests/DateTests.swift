//
//  DateTests.swift
//  WeatherTests
//
//  Created by jonathan saville on 31/08/2023.
//

import XCTest
@testable import Weather

final class DateTests: XCTestCase {

    let tokyoSecondsFromGMT: Int = DateTests.secondsIn(hours: 9)       // Tokyo does not use daylight saving time
    let honoluluSecondsFromGMT: Int = DateTests.secondsIn(hours: -10)  // Hawaii does not use daylight saving time
    let londonSecondsFromGMT: Int = DateTests.secondsIn(hours: 1)      // London does use daylight saving time (of course) - and it is included in the timezoneOffset sent by the API

    func testDayOfWeek() {
        continueAfterFailure = false
        let oct_25_08AM_GMT = Date(timeIntervalSince1970: 1698220800)
        XCTAssertEqual(oct_25_08AM_GMT.dayOfWeek(londonSecondsFromGMT), "Wed")
        XCTAssertEqual(oct_25_08AM_GMT.dayOfWeek(tokyoSecondsFromGMT), "Wed")
        XCTAssertEqual(oct_25_08AM_GMT.dayOfWeek(honoluluSecondsFromGMT), "Tue")

        let oct_25_08PM_GMT = Date(timeIntervalSince1970: 1698264000)
        XCTAssertEqual(oct_25_08PM_GMT.dayOfWeek(londonSecondsFromGMT), "Wed")
        XCTAssertEqual(oct_25_08PM_GMT.dayOfWeek(tokyoSecondsFromGMT), "Thu")
        XCTAssertEqual(oct_25_08PM_GMT.dayOfWeek(honoluluSecondsFromGMT), "Wed")

        XCTAssertEqual(Date().dayOfWeek(0), "Today")
    }

    func testFormattedTime() {
        continueAfterFailure = false
        let oct_25_08AM_GMT = Date(timeIntervalSince1970: 1698220800)
        XCTAssertEqual(oct_25_08AM_GMT.formattedTime(londonSecondsFromGMT), "09:00")
        XCTAssertEqual(oct_25_08AM_GMT.formattedTime(tokyoSecondsFromGMT), "17:00")
        XCTAssertEqual(oct_25_08AM_GMT.formattedTime(honoluluSecondsFromGMT), "22:00")

        let oct_25_08PM_GMT = Date(timeIntervalSince1970: 1698264000)
        XCTAssertEqual(oct_25_08PM_GMT.formattedTime(londonSecondsFromGMT), "21:00")
        XCTAssertEqual(oct_25_08PM_GMT.formattedTime(tokyoSecondsFromGMT), "05:00")
        XCTAssertEqual(oct_25_08PM_GMT.formattedTime(honoluluSecondsFromGMT), "10:00")
    }

    private static func secondsIn(hours: Int) -> Int {
        hours * 60 * 60
    }
}
