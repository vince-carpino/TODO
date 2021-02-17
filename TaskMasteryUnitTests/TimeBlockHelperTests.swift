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

    func testGetFinalTimeBlocksFillsInOneEmptyTimeSlot() {
        let originalTimeBlocks: [TimeBlock] = [
            TimeBlock(name: "first item", color: .red, startTime: 8, endTime: 9),
            TimeBlock(name: "second item", color: .orange, startTime: 9, endTime: 10),
            TimeBlock(name: "third item", color: .yellow, startTime: 11, endTime: 12)
        ]

        let expectedFinalTimeBlocks: [TimeBlock] = [
            TimeBlock(name: "first item", color: .red, startTime: 8, endTime: 9),
            TimeBlock(name: "second item", color: .orange, startTime: 9, endTime: 10),
            UnusedTimeBlock(startTime: 10, endTime: 11),
            TimeBlock(name: "third item", color: .yellow, startTime: 11, endTime: 12)
        ]

        let actualFinalTimeBlocks: [TimeBlock] = TimeBlockHelper.getFinalTimeBlocks(originalTimeBlocks: originalTimeBlocks)

        XCTAssertEqual(actualFinalTimeBlocks, expectedFinalTimeBlocks)
    }

    func testGetFinalTimeBlocksFillsInTwoEmptyTimeSlots() {
        let originalTimeBlocks: [TimeBlock] = [
            TimeBlock(name: "first item", color: .red, startTime: 8, endTime: 9),
            TimeBlock(name: "second item", color: .orange, startTime: 9, endTime: 10),
            TimeBlock(name: "third item", color: .yellow, startTime: 11, endTime: 12),
            TimeBlock(name: "fourth item", color: .green, startTime: 15, endTime: 16)
        ]

        let expectedFinalTimeBlocks: [TimeBlock] = [
            TimeBlock(name: "first item", color: .red, startTime: 8, endTime: 9),
            TimeBlock(name: "second item", color: .orange, startTime: 9, endTime: 10),
            UnusedTimeBlock(startTime: 10, endTime: 11),
            TimeBlock(name: "third item", color: .yellow, startTime: 11, endTime: 12),
            UnusedTimeBlock(startTime: 12, endTime: 15),
            TimeBlock(name: "fourth item", color: .green, startTime: 15, endTime: 16)
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

    func testGetFinalTimeBlocksReturnsOriginalListIfNoFreeSpace() {
        let original: [TimeBlock] = [
            TimeBlock(name: "first", color: .red, startTime: 8, endTime: 9),
            TimeBlock(name: "second", color: .orange, startTime: 9, endTime: 10),
            TimeBlock(name: "third", color: .yellow, startTime: 10, endTime: 11)
        ]

        let actual: [TimeBlock] = TimeBlockHelper.getFinalTimeBlocks(originalTimeBlocks: original)

        XCTAssertEqual(actual, original)
    }
}
