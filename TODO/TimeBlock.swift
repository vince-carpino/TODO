//
//  TimeBlock.swift
//  TODO
//
//  Created by Vince Carpino on 1/29/21.
//  Copyright © 2021 Vince Carpino. All rights reserved.
//

import SwiftUI

class TimeBlock: Equatable {
    var name: String
    var color: Color
    var startTime: Float
    var endTime: Float

    init() {
        self.name = ""
        self.color = .clear
        self.startTime = 0
        self.endTime = 0
    }

    init(name: String, color: Color, startTime: Float, endTime: Float) {
        self.name = name
        self.color = color
        self.startTime = startTime
        self.endTime = endTime
    }

    static func == (lhs: TimeBlock, rhs: TimeBlock) -> Bool {
        return lhs.name == rhs.name
            && lhs.color == rhs.color
            && lhs.startTime == rhs.startTime
            && lhs.endTime == rhs.endTime
    }
}

class UnusedTimeBlock: TimeBlock {
    init(startTime: Float, endTime: Float) {
        super.init(name: "", color: .unusedTimeBlockColor, startTime: startTime, endTime: endTime)
    }
}
