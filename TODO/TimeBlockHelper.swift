//
//  TimeBlockHelper.swift
//  TODO
//
//  Created by Vince Carpino on 1/29/21.
//  Copyright © 2021 Vince Carpino. All rights reserved.
//

class TimeBlockHelper {
    static func getFinalTimeBlocks(originalTimeBlocks: [TimeBlock]) -> [TimeBlock] {
        var newTimeBlocks: [TimeBlock] = []
        newTimeBlocks.append(originalTimeBlocks[0])

        for i in 0..<originalTimeBlocks.count - 1 {
            let currentTimeBlock = originalTimeBlocks[i]
            let nextTimeBlock = originalTimeBlocks[i + 1]

            if currentTimeBlock.endTime != nextTimeBlock.startTime {
                let filler = UnusedTimeBlock(startTime: currentTimeBlock.endTime, endTime: nextTimeBlock.startTime)
                newTimeBlocks.append(filler)
            }

            newTimeBlocks.append(nextTimeBlock)
        }

        return newTimeBlocks
    }
}
