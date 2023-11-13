//
//  WindDirectionTests.swift
//  WeatherTests
//
//  Created by jonathan saville on 31/08/2023.
//

import XCTest
@testable import Weather

final class WindDirectionTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testCardinals() throws {
        XCTAssertEqual(WindDirection.fromDegrees(0), WindDirection.North)
        XCTAssertEqual(WindDirection.fromDegrees(11), WindDirection.North)
        XCTAssertEqual(WindDirection.fromDegrees(12), WindDirection.NorthNorthEast)
        XCTAssertEqual(WindDirection.fromDegrees(33), WindDirection.NorthNorthEast)
        XCTAssertEqual(WindDirection.fromDegrees(34), WindDirection.NorthEast)
        XCTAssertEqual(WindDirection.fromDegrees(56), WindDirection.NorthEast)
        XCTAssertEqual(WindDirection.fromDegrees(57), WindDirection.EastNorthEast)
        XCTAssertEqual(WindDirection.fromDegrees(78), WindDirection.EastNorthEast)
        XCTAssertEqual(WindDirection.fromDegrees(79), WindDirection.East)
        XCTAssertEqual(WindDirection.fromDegrees(101), WindDirection.East)
        XCTAssertEqual(WindDirection.fromDegrees(102), WindDirection.EastSouthEast)
        XCTAssertEqual(WindDirection.fromDegrees(123), WindDirection.EastSouthEast)
        XCTAssertEqual(WindDirection.fromDegrees(124), WindDirection.SouthEast)
        XCTAssertEqual(WindDirection.fromDegrees(146), WindDirection.SouthEast)
        XCTAssertEqual(WindDirection.fromDegrees(147), WindDirection.SouthSouthEast)
        XCTAssertEqual(WindDirection.fromDegrees(168), WindDirection.SouthSouthEast)
        XCTAssertEqual(WindDirection.fromDegrees(169), WindDirection.South)
        XCTAssertEqual(WindDirection.fromDegrees(191), WindDirection.South)
        XCTAssertEqual(WindDirection.fromDegrees(192), WindDirection.SouthSouthWest)
        XCTAssertEqual(WindDirection.fromDegrees(213), WindDirection.SouthSouthWest)
        XCTAssertEqual(WindDirection.fromDegrees(214), WindDirection.SouthWest)
        XCTAssertEqual(WindDirection.fromDegrees(236), WindDirection.SouthWest)
        XCTAssertEqual(WindDirection.fromDegrees(237), WindDirection.WestSouthWest)
        XCTAssertEqual(WindDirection.fromDegrees(258), WindDirection.WestSouthWest)
        XCTAssertEqual(WindDirection.fromDegrees(259), WindDirection.West)
        XCTAssertEqual(WindDirection.fromDegrees(281), WindDirection.West)
        XCTAssertEqual(WindDirection.fromDegrees(282), WindDirection.WestNorthWest)
        XCTAssertEqual(WindDirection.fromDegrees(303), WindDirection.WestNorthWest)
        XCTAssertEqual(WindDirection.fromDegrees(304), WindDirection.NorthWest)
        XCTAssertEqual(WindDirection.fromDegrees(326), WindDirection.NorthWest)
        XCTAssertEqual(WindDirection.fromDegrees(327), WindDirection.NorthNorthWest)
        XCTAssertEqual(WindDirection.fromDegrees(348), WindDirection.NorthNorthWest)
        XCTAssertEqual(WindDirection.fromDegrees(349), WindDirection.North)
        XCTAssertEqual(WindDirection.fromDegrees(360), WindDirection.North)
    }
    
    func testGreaterThan360() throws {
        XCTAssertEqual(WindDirection.fromDegrees(540), WindDirection.South)
    }

    func testRawValues() {
        XCTAssertEqual(WindDirection.North.rawValue, "N")
        XCTAssertEqual(WindDirection.NorthNorthEast.rawValue, "NNE")
        XCTAssertEqual(WindDirection.NorthEast.rawValue, "NE")
        XCTAssertEqual(WindDirection.EastNorthEast.rawValue, "ENE")
        XCTAssertEqual(WindDirection.East.rawValue, "E")
        XCTAssertEqual(WindDirection.EastSouthEast.rawValue, "ESE")
        XCTAssertEqual(WindDirection.SouthEast.rawValue, "SE")
        XCTAssertEqual(WindDirection.SouthSouthEast.rawValue, "SSE")
        XCTAssertEqual(WindDirection.South.rawValue, "S")
        XCTAssertEqual(WindDirection.SouthSouthWest.rawValue, "SSW")
        XCTAssertEqual(WindDirection.SouthWest.rawValue, "SW")
        XCTAssertEqual(WindDirection.WestSouthWest.rawValue, "WSW")
        XCTAssertEqual(WindDirection.West.rawValue, "W")
        XCTAssertEqual(WindDirection.WestNorthWest.rawValue, "WNW")
        XCTAssertEqual(WindDirection.NorthWest.rawValue, "NW")
        XCTAssertEqual(WindDirection.NorthNorthWest.rawValue, "NNW")
    }
}
