//
//  TimeBlockHelperTests.swift
//  TaskMasteryUnitTests
//
//  Created by Vince Carpino on 9/18/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import XCTest
@testable import Task_Mastery

class TimeBlockHelperTests: XCTestCase {

    func testGetFinalTimeBlocksFillsInEmptyTimeslots() {
        let originalTimeBlocks: [TimeBlock] = [
            TimeBlock(name: "first item", color: .red, startTime: 8, endTime: 9),
            TimeBlock(name: "second item", color: .orange, startTime: 9, endTime: 10),
            TimeBlock(name: "third item", color: .yellow, startTime: 11, endTime: 12)
        ]

        let expectedFinalTimeBlocks: [TimeBlock] = [
            TimeBlock(name: "first item", color: .red, startTime: 8, endTime: 9),
            TimeBlock(name: "second item", color: .orange, startTime: 9, endTime: 10),
            TimeBlockSpacer(startTime: 10, endTime: 11),
            TimeBlock(name: "third item", color: .yellow, startTime: 11, endTime: 12)
        ]

        let actualFinalTimeBlocks: [TimeBlock] = TimeBlockHelper.getFinalTimeBlocks(originalTimeBlocks: originalTimeBlocks)

        XCTAssertEqual(actualFinalTimeBlocks, expectedFinalTimeBlocks)
    }

    func testGetFinalTimeBlocksReturnsOriginalListIfCountIsLessThanTwo() {
        let originalTimeBlocks: [TimeBlock] = [
            TimeBlock(name: "only item", color: .red, startTime: 8, endTime: 9)
        ]

        let actualFinalTimeBlocks: [TimeBlock] = TimeBlockHelper.getFinalTimeBlocks(originalTimeBlocks: originalTimeBlocks)

        XCTAssertEqual(actualFinalTimeBlocks, originalTimeBlocks)
    }
}
