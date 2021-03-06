import XCTest
@testable import Task_Mastery

class TimelineSeparatorTests: XCTestCase {
    func testGetHourReturns12AM() {
        let hourPastMidnight: Float = 0
        let expected = "12 AM"

        let actual = TimelineSeparator.getHour(hourPastMidnight: hourPastMidnight)

        XCTAssertEqual(actual, expected)
    }

    func testGetHourReturns12_30AM() {
        let hourPastMidnight: Float = 0.5
        let expected = "12:30 AM"

        let actual = TimelineSeparator.getHour(hourPastMidnight: hourPastMidnight)

        XCTAssertEqual(actual, expected)
    }

    func testGetHourReturns12PM() {
        let hourPastMidnight: Float = 12
        let expected = "12 PM"

        let actual = TimelineSeparator.getHour(hourPastMidnight: hourPastMidnight)

        XCTAssertEqual(actual, expected)
    }

    func testGetHourReturns12_30PM() {
        let hourPastMidnight: Float = 12.5
        let expected = "12:30 PM"

        let actual = TimelineSeparator.getHour(hourPastMidnight: hourPastMidnight)

        XCTAssertEqual(actual, expected)
    }

    func testGetHourReturns12AMNextDay() {
        let hourPastMidnight: Float = 24
        let expected = "12 AM"

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
