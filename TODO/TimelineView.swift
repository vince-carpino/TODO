//
//  TimelineView.swift
//  TODO
//
//  Created by Vince Carpino on 8/21/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import SwiftUI

struct TimelineView: View {
    let timeBlocks: [TimeBlock]

    private let timelineSeparatorWidth: CGFloat = 65

    var body: some View {
        ZStack {
            BackgroundView()

            VStack {
                Text("TODAY")
                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                    .foregroundColor(.clouds)

                ScrollView(showsIndicators: false) {
                    ZStack {
                        VStack(spacing: 0) {
                            ForEach(0..<timeBlocks.count) { index in
                                TimelineSeparator(hour: self.timeBlocks[index].startTime)

                                HStack {
                                    Spacer()
                                        .frame(width: self.timelineSeparatorWidth)

                                    TimelineItem(timeBlock: self.timeBlocks[index])
                                }

                                if index == self.timeBlocks.count - 1 {
                                    TimelineSeparator(hour: self.timeBlocks[index].endTime)
                                }
                            }

                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            }
        }
    }
}

class TimeBlock: Equatable {
    static func == (lhs: TimeBlock, rhs: TimeBlock) -> Bool {
        return lhs.name == rhs.name
            && lhs.color == rhs.color
            && lhs.startTime == rhs.startTime
            && lhs.endTime == rhs.endTime
    }

    var name: String
    var color: Color
    var startTime: Double
    var endTime: Double

    init(name: String, color: Color, startTime: Double, endTime: Double) {
        self.name = name
        self.color = color
        self.startTime = startTime
        self.endTime = endTime
    }
}

class TimeBlockSpacer: TimeBlock {
    init(startTime: Double, endTime: Double) {
        super.init(name: "free", color: .clear, startTime: startTime, endTime: endTime)
    }
}

class TimeBlockHelper {
    static func getFinalTimeBlocks(originalTimeBlocks: [TimeBlock]) -> [TimeBlock] {
        var newTimeBlocks: [TimeBlock] = []
        newTimeBlocks.append(contentsOf: originalTimeBlocks)

        for i in 1..<originalTimeBlocks.count {
            let currentTimeBlock = originalTimeBlocks[i]
            let previousTimeBlock = originalTimeBlocks[i - 1]

            if currentTimeBlock.startTime != previousTimeBlock.endTime {
                let freeTime = TimeBlockSpacer(startTime: previousTimeBlock.endTime, endTime: currentTimeBlock.startTime)
                let indexOfCurrentTimeBlock = originalTimeBlocks.firstIndex { (timeBlock) -> Bool in
                    timeBlock.startTime == currentTimeBlock.startTime
                }

                newTimeBlocks.insert(freeTime, at: indexOfCurrentTimeBlock!)
            }
        }

        return newTimeBlocks
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        let incompleteTimeBlocks: [TimeBlock] = [
            TimeBlock(name: "work", color: .blue, startTime: 8, endTime: 12),
            TimeBlock(name: "lunch", color: .green, startTime: 12, endTime: 13),
            TimeBlock(name: "work", color: .blue, startTime: 13, endTime: 16),
            TimeBlock(name: "learning session", color: .clementine, startTime: 16, endTime: 17),
            TimeBlock(name: "workout", color: .red, startTime: 17, endTime: 17.5),
            TimeBlock(name: "dinner", color: .purple, startTime: 18, endTime: 19),
            TimeBlock(name: "tomorrow prep", color: .yellow, startTime: 19, endTime: 19.5)
        ]

        let completeTimeBlocks: [TimeBlock] = TimeBlockHelper.getFinalTimeBlocks(originalTimeBlocks: incompleteTimeBlocks)

        return TimelineView(timeBlocks: completeTimeBlocks)
    }
}

struct TimelineItem: View {
    let timeBlock: TimeBlock
    var name: Binding<String>?

    private let cornerRadius: CGFloat = 5
    private let baseHeight: CGFloat = 70

    var body: some View {
        Button(action: {}) {
            HStack {
                Text(name?.wrappedValue.uppercased() ?? timeBlock.name.uppercased())
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .bold()
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .frame(maxWidth: .infinity, minHeight: calculateHeight(), maxHeight: calculateHeight())
            .padding(10)
            .foregroundColor(.clouds)
            .background(timeBlock.color)
            .cornerRadius(self.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .strokeBorder(Color.clouds, lineWidth: 3)
            )
        }
    }

    func calculateHeight() -> CGFloat {
        return CGFloat(timeBlock.endTime - timeBlock.startTime) * baseHeight
    }
}

struct TimelineSeparator: View {
    var hour: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(TimelineSeparator.getHour(hourPastMidnight: hour))
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(.clouds)

            Divider()
                .background(Color.clouds)
        }
        .clipped(antialiased: false)
        .frame(height: 1)
        .offset(x: 0, y: -9)
    }

    static func getHour(hourPastMidnight: Double) -> String {
        let amPm = hourPastMidnight < 12 ? "AM" : "PM"
        let isPartialHour = floor(hourPastMidnight) != hourPastMidnight
        var hourNumber = hourPastMidnight

        if hourPastMidnight == 0 {
            hourNumber = 12
        } else if hourPastMidnight > 12 {
            hourNumber = hourPastMidnight - 12
        }

        if isPartialHour {
            let minutes = (hourNumber - floor(hourNumber)) * 60
            return "\(Int(hourNumber)):\(Int(minutes)) \(amPm)"
        }

        return "\(Int(hourNumber)) \(amPm)"
    }
}

struct BackgroundView: View {
    var body: some View {
        Color.midnightBlue
            .edgesIgnoringSafeArea(.all)
    }
}
