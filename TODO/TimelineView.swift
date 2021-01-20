//
//  TimelineView.swift
//  TODO
//
//  Created by Vince Carpino on 8/21/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import SwiftUI

struct TimelineView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: StoredTimeBlock.entity(), sortDescriptors: [
        NSSortDescriptor(key: "startTime", ascending: true)
    ]) var timeBlocksCoreData: FetchedResults<StoredTimeBlock>

    private let timelineSeparatorWidth: CGFloat = 65

    var body: some View {
        ZStack {
            BackgroundView()

            VStack {
                Text("TODAY")
                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                    .foregroundColor(.clouds)

                if timeBlocksCoreData.count == 0 {
                    EmptyTimelineView()
                } else {
                    ScrollView(showsIndicators: false) {
                        ZStack {
                            VStack(spacing: 0) {
                                ForEach(timeBlocksCoreData, id: \.id) { timeBlock in
                                    TimelineSeparator(hour: timeBlock.startTime)

                                    HStack {
                                        Spacer()
                                            .frame(width: self.timelineSeparatorWidth)

                                        TimelineItem(timeBlock: TimeBlock(), storedTimeBlock: timeBlock)
                                    }

                                    if timeBlock == self.timeBlocksCoreData.last {
                                        TimelineSeparator(hour: timeBlock.endTime)
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
}

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

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
//        let incompleteTimeBlocks: [TimeBlock] = [
//            TimeBlock(name: "work", color: .blue, startTime: 8, endTime: 12),
//            TimeBlock(name: "lunch", color: .green, startTime: 12, endTime: 13),
//            TimeBlock(name: "work", color: .blue, startTime: 13, endTime: 16),
//            TimeBlock(name: "learning session", color: .orange, startTime: 16, endTime: 17),
//            TimeBlock(name: "workout", color: .red, startTime: 17, endTime: 17.5),
//            TimeBlock(name: "dinner", color: .purple, startTime: 18, endTime: 19),
//            TimeBlock(name: "tomorrow prep", color: .yellow, startTime: 19, endTime: 19.5)
//        ]
//
//        let completeTimeBlocks: [TimeBlock] = TimeBlockHelper.getFinalTimeBlocks(originalTimeBlocks: incompleteTimeBlocks)

//        return TimelineView(timeBlocks: completeTimeBlocks)
        return TimelineView()
    }
}

struct TimelineItem: View {
    @Environment(\.managedObjectContext) var moc
    @State private var isPresentingAddEditView = false

    let timeBlock: TimeBlock
    let storedTimeBlock: StoredTimeBlock?

    private let cornerRadius: CGFloat = 5
    private let baseHeight: CGFloat = 70

    var body: some View {
        Button(action: {
            self.isPresentingAddEditView.toggle()
        }) {
            HStack {
                if self.storedTimeBlock?.isUnused ?? true {
                    Image(systemName: "plus")
                }

                Text(storedTimeBlock?.name?.uppercased() ?? "")
                    .bold()
                    .lineLimit(1)
                    .truncationMode(.tail)

//                if self.timeBlock is UnusedTimeBlock {
//                    Image(systemName: "plus")
//                }

//                Text(timeBlock.name.uppercased())
//                    .bold()
//                    .lineLimit(1)
//                    .truncationMode(.tail)
            }
            .font(.system(size: 20, weight: .semibold, design: .rounded))
            .frame(maxWidth: .infinity, minHeight: calculateHeight(), maxHeight: calculateHeight())
            .padding(10)
            .foregroundColor(.clouds)
            .background(getColorFromColorName())
            .cornerRadius(self.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .strokeBorder(Color.clouds, lineWidth: 5)
            )
        }
        .fullScreenCover(isPresented: $isPresentingAddEditView, content: {
            AddEditTimelineItemView(storedTimeBlock: nil)
//            AddEditTimelineItemView(timeBlock: timeBlock)
        })
    }

    func calculateHeight() -> CGFloat {
        return CGFloat((storedTimeBlock?.endTime ?? 9) - (storedTimeBlock?.startTime ?? 8)) * baseHeight
//        return CGFloat(timeBlock.endTime - timeBlock.startTime) * baseHeight
    }

    func getColorFromColorName() -> Color {
        return Color.coreDataLegend.someKey(forValue: storedTimeBlock?.colorName ?? "clear") ?? .clear
    }
}

struct TimelineItemPreview: View {
//    let timeBlock: TimeBlock
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

struct EmptyTimelineView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var isShowingAddEditTimeBlockView: Bool = false

    var body: some View {
        VStack {
            Spacer()

            Text("Nothing here...")
                .foregroundColor(.clouds)
                .font(.system(size: 20, weight: .semibold, design: .rounded))

            Spacer()

            Button(action: {
                self.isShowingAddEditTimeBlockView.toggle()
            }) {
                HStack {
                    Image(systemName: "plus")

                    Text("Add")
                }
                .padding()
                .foregroundColor(.clouds)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
            }
            .background(Color.peterRiver)
            .cornerRadius(5)
            .fullScreenCover(isPresented: $isShowingAddEditTimeBlockView, content: {
                AddEditTimelineItemView(storedTimeBlock: nil)
//                AddEditTimelineItemView(timeBlock: UnusedTimeBlock(startTime: 8, endTime: 9))
            })
        }
    }
}
