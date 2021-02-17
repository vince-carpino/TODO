import XCTest
import SwiftUI
@testable import Task_Mastery

class TimeBlockSpacerTests: XCTestCase {

    func testTimeBlockSpacerHasCorrectDefaultProperties() {
        let expectedName = ""
        let expectedColor = Color.unusedTimeBlockColor

        let newTimeBlockSpacer = UnusedTimeBlock(startTime: 8, endTime: 9)

        XCTAssertEqual(newTimeBlockSpacer.color, expectedColor)
        XCTAssertEqual(newTimeBlockSpacer.name, expectedName)
    }
}
