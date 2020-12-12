//
//  TimelineSeparatorTests.swift
//  TaskMasteryUnitTests
//
//  Created by Vince Carpino on 9/21/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

@testable import Task_Mastery
import XCTest

class TimelineSeparatorTests: XCTestCase {
    func testGetHourReturns12AM() {
        let hourPastMidnight: Float = 0
        let expected = "12 AM"

        let actual = TimelineSeparator.getHour(hourPastMidnight: hourPastMidnight)

        XCTAssertEqual(actual, expected)
    }

    func testGetHourReturns12PM() {
        let hourPastMidnight: Float = 12
        let expected = "12 PM"

        let actual = TimelineSeparator.getHour(hourPastMidnight: hourPastMidnight)

        XCTAssertEqual(actual, expected)
    }

    func testGetHourReturnsCorrectPartialHourFor15Minutes() {
        let hourPastMidnight: Float = 8.25
        let expected = "8:15 AM"

        let actual = TimelineSeparator.getHour(hourPastMidnight: hourPastMidnight)

        XCTAssertEqual(actual, expected)
    }

    func testGetHourReturnsCorrectPartialHourFor30Minutes() {
        let hourPastMidnight: Float = 20.5
        let expected = "8:30 PM"

        let actual = TimelineSeparator.getHour(hourPastMidnight: hourPastMidnight)

        XCTAssertEqual(actual, expected)
    }
}
