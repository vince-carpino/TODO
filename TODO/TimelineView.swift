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

//class TimeBlock: Equatable {
//    static func == (lhs: TimeBlock, rhs: TimeBlock) -> Bool {
//        return lhs.name == rhs.name
//            && lhs.color == rhs.color
//            && lhs.startTime == rhs.startTime
//            && lhs.endTime == rhs.endTime
//    }
//
//    var name: String
//    var color: Color
//    var startTime: Float
//    var endTime: Float
//
//    init(name: String, color: Color, startTime: Float, endTime: Float) {
//        self.name = name
//        self.color = color
//        self.startTime = startTime
//        self.endTime = endTime
//    }
//}

//class UnusedTimeBlock: TimeBlock {
//    init(startTime: Float, endTime: Float) {
//        super.init(name: "", color: .unusedTimeBlockColor, startTime: startTime, endTime: endTime)
//    }
//}

class TimeBlockHelper {
    static func getFinalTimeBlocks(originalTimeBlocks: [TimeBlock]) -> [TimeBlock] {
        var newTimeBlocks: [TimeBlock] = []
        newTimeBlocks.append(originalTimeBlocks[0])

        for i in 0..<originalTimeBlocks.count - 1 {
            let currentTimeBlock = originalTimeBlocks[i]
            let nextTimeBlock = originalTimeBlocks[i + 1]

            if currentTimeBlock.endTime != nextTimeBlock.startTime {
                let filler = TimeBlock()
//                let filler = UnusedTimeBlock(startTime: currentTimeBlock.endTime, endTime: nextTimeBlock.startTime)
                newTimeBlocks.append(filler)
            }

            newTimeBlocks.append(nextTimeBlock)
        }

        return newTimeBlocks
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        let incompleteTimeBlocks: [TimeBlock] = [
//            TimeBlock(name: "work", color: .blue, startTime: 8, endTime: 12),
//            TimeBlock(name: "lunch", color: .green, startTime: 12, endTime: 13),
//            TimeBlock(name: "work", color: .blue, startTime: 13, endTime: 16),
//            TimeBlock(name: "learning session", color: .orange, startTime: 16, endTime: 17),
//            TimeBlock(name: "workout", color: .red, startTime: 17, endTime: 17.5),
//            TimeBlock(name: "dinner", color: .purple, startTime: 18, endTime: 19),
//            TimeBlock(name: "tomorrow prep", color: .yellow, startTime: 19, endTime: 19.5)
        ]

        let completeTimeBlocks: [TimeBlock] = TimeBlockHelper.getFinalTimeBlocks(originalTimeBlocks: incompleteTimeBlocks)

        return TimelineView(timeBlocks: completeTimeBlocks)
    }
}

struct TimelineItem: View {
    @State private var isPresentingAddEditView = false

    let timeBlock: TimeBlock

    private let cornerRadius: CGFloat = 5
    private let baseHeight: CGFloat = 70

    var body: some View {
        Button(action: {
            self.isPresentingAddEditView.toggle()
        }) {
            HStack {
                if Color.coreDataLegend.someKey(forValue: timeBlock.colorName ?? "clear") ?? .clear == .unusedTimeBlockColor {
                    Image(systemName: "plus")
                }

                Text(timeBlock.name?.uppercased() ?? "NO NAME")
                    .bold()
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .font(.system(size: 20, weight: .semibold, design: .rounded))
            .frame(maxWidth: .infinity, minHeight: calculateHeight(), maxHeight: calculateHeight())
            .padding(10)
            .foregroundColor(.clouds)
            .background(Color.coreDataLegend.someKey(forValue: timeBlock.colorName ?? "clear") ?? .clear)
            .cornerRadius(self.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .strokeBorder(Color.clouds, lineWidth: 5)
            )
        }
        .fullScreenCover(isPresented: $isPresentingAddEditView, content: {
            AddEditTimelineItemView(timeBlock: timeBlock)
        })
    }

    func calculateHeight() -> CGFloat {
        return CGFloat(timeBlock.endTime - timeBlock.startTime) * baseHeight
    }
}

struct TimelineItemPreview: View {
    let timeBlock: TimeBlock
    var name: Binding<String>
    var color: Binding<Color>

    private let cornerRadius: CGFloat = 5
    private let baseHeight: CGFloat = 70

    var body: some View {
        Button(action: {}) {
            HStack {
                Text(name.wrappedValue.uppercased())
                    .bold()
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .font(.system(size: 20, weight: .semibold, design: .rounded))
            .frame(maxWidth: .infinity, minHeight: baseHeight, maxHeight: baseHeight)
            .padding(10)
            .foregroundColor(.clouds)
            .background(color.wrappedValue)
            .cornerRadius(self.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .strokeBorder(Color.clouds, lineWidth: 5)
            )
        }
        .disabled(true)
    }
}

struct TimelineSeparator: View {
    var hour: Float

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

    static func getHour(hourPastMidnight: Float) -> String {
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

extension Float {
    static func getHour(_ hourPastMidnight: Float) -> String {
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
        Color.backgroundColor
            .edgesIgnoringSafeArea(.all)
    }
}
