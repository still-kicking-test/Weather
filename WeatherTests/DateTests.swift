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

    func testShortDayOfWeek() {
        continueAfterFailure = false
        let dateOct_25_08AM_GMT = Date(timeIntervalSince1970: 1698220800)
        XCTAssertEqual(dateOct_25_08AM_GMT.shortDayOfWeek(londonSecondsFromGMT), "Wed")
        XCTAssertEqual(dateOct_25_08AM_GMT.shortDayOfWeek(tokyoSecondsFromGMT), "Wed")
        XCTAssertEqual(dateOct_25_08AM_GMT.shortDayOfWeek(honoluluSecondsFromGMT), "Tue")

        let dateOct_25_08PM_GMT = Date(timeIntervalSince1970: 1698264000)
        XCTAssertEqual(dateOct_25_08PM_GMT.shortDayOfWeek(londonSecondsFromGMT), "Wed")
        XCTAssertEqual(dateOct_25_08PM_GMT.shortDayOfWeek(tokyoSecondsFromGMT), "Thu")
        XCTAssertEqual(dateOct_25_08PM_GMT.shortDayOfWeek(honoluluSecondsFromGMT), "Wed")
    }

    func testFormattedTime() {
        continueAfterFailure = false
        let dateOct_25_08AM_GMT = Date(timeIntervalSince1970: 1698220800)
        XCTAssertEqual(dateOct_25_08AM_GMT.formattedTime(londonSecondsFromGMT), "09:00")
        XCTAssertEqual(dateOct_25_08AM_GMT.formattedTime(tokyoSecondsFromGMT), "17:00")
        XCTAssertEqual(dateOct_25_08AM_GMT.formattedTime(honoluluSecondsFromGMT), "22:00")

        let dateOct_25_08PM_GMT = Date(timeIntervalSince1970: 1698264000)
        XCTAssertEqual(dateOct_25_08PM_GMT.formattedTime(londonSecondsFromGMT), "21:00")
        XCTAssertEqual(dateOct_25_08PM_GMT.formattedTime(tokyoSecondsFromGMT), "05:00")
        XCTAssertEqual(dateOct_25_08PM_GMT.formattedTime(honoluluSecondsFromGMT), "10:00")
    }

    private static func secondsIn(hours: Int) -> Int {
        hours * 60 * 60
    }
}
