//
//  TimeBlockSpacerTests.swift
//  TaskMasteryUnitTests
//
//  Created by Vince Carpino on 9/21/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import XCTest
import SwiftUI
@testable import Task_Mastery

class TimeBlockSpacerTests: XCTestCase {

    func testTimeBlockSpacerHasCorrectDefaultProperties() {
        let expectedName = "free"
        let expectedColor = Color.clear

        let newTimeBlockSpacer = TimeBlockSpacer(startTime: 8, endTime: 9)

        XCTAssertEqual(newTimeBlockSpacer.color, expectedColor)
        XCTAssertEqual(newTimeBlockSpacer.name, expectedName)
    }
}