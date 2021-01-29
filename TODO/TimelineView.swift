//
//  TimelineView.swift
//  TODO
//
//  Created by Vince Carpino on 8/21/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import CoreData
import SwiftUI

struct TimelineView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: StoredTimeBlock.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \StoredTimeBlock.startTime, ascending: true)
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

                                        TimelineItem(storedTimeBlock: timeBlock)
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

// class TimeBlock: Equatable {
//    var name: String
//    var color: Color
//    var startTime: Float
//    var endTime: Float
//
//    init() {
//        self.name = ""
//        self.color = .clear
//        self.startTime = 0
//        self.endTime = 0
//    }
//
//    init(name: String, color: Color, startTime: Float, endTime: Float) {
//        self.name = name
//        self.color = color
//        self.startTime = startTime
//        self.endTime = endTime
//    }
//
//    static func == (lhs: TimeBlock, rhs: TimeBlock) -> Bool {
//        return lhs.name == rhs.name
//            && lhs.color == rhs.color
//            && lhs.startTime == rhs.startTime
//            && lhs.endTime == rhs.endTime
//    }
// }
//
// class UnusedTimeBlock: TimeBlock {
//    init(startTime: Float, endTime: Float) {
//        super.init(name: "", color: .unusedTimeBlockColor, startTime: startTime, endTime: endTime)
//    }
// }

// class TimeBlockHelper {
//    static func getFinalTimeBlocks(originalTimeBlocks: [TimeBlock]) -> [TimeBlock] {
//        var newTimeBlocks: [TimeBlock] = []
//        newTimeBlocks.append(originalTimeBlocks[0])
//
//        for i in 0..<originalTimeBlocks.count - 1 {
//            let currentTimeBlock = originalTimeBlocks[i]
//            let nextTimeBlock = originalTimeBlocks[i + 1]
//
//            if currentTimeBlock.endTime != nextTimeBlock.startTime {
//                let filler = UnusedTimeBlock(startTime: currentTimeBlock.endTime, endTime: nextTimeBlock.startTime)
//                newTimeBlocks.append(filler)
//            }
//
//            newTimeBlocks.append(nextTimeBlock)
//        }
//
//        return newTimeBlocks
//    }
// }

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let storedTimeBlock1 = StoredTimeBlock(context: moc)
        storedTimeBlock1.name = "First thing"
        storedTimeBlock1.colorName = "alizarin"
        storedTimeBlock1.startTime = 8
        storedTimeBlock1.endTime = 9

        return TimelineView().environment(\.managedObjectContext, moc)
    }
}

struct TimelineItem: View {
    @Environment(\.managedObjectContext) var moc
    @State private var isPresentingAddEditView = false

    let storedTimeBlock: StoredTimeBlock

    private let cornerRadius: CGFloat = 5
    private let baseHeight: CGFloat = 70

    var body: some View {
        Button(action: {
            self.isPresentingAddEditView.toggle()
        }) {
            HStack {
                if self.storedTimeBlock.isUnused {
                    Image(systemName: "plus")
                }

                Text(storedTimeBlock.name?.uppercased() ?? "")
                    .bold()
                    .lineLimit(1)
                    .truncationMode(.tail)
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
            AddEditTimelineItemView(storedTimeBlock: storedTimeBlock).environment(\.managedObjectContext, moc)
        })
    }

    func calculateHeight() -> CGFloat {
        return CGFloat(storedTimeBlock.endTime - storedTimeBlock.startTime) * baseHeight
    }

    func getColorFromColorName() -> Color {
        return Color.coreDataLegend.someKey(forValue: storedTimeBlock.colorName ?? "clear") ?? .clear
    }
}

struct TimelineItemPreview: View {
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
        var hourNumber = floor(hourPastMidnight)

        if hourNumber == 0 {
            hourNumber = 12
        } else if hourNumber > 12 {
            hourNumber = hourPastMidnight - 12
        }

        if isPartialHour {
            let minutes = (hourPastMidnight - floor(hourPastMidnight)) * 60
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
    @State private var isShowingAddEditTimelineItemView: Bool = false

    var body: some View {
        VStack {
            Spacer()

            Text("Nothing here...")
                .foregroundColor(.clouds)
                .font(.system(size: 20, weight: .semibold, design: .rounded))

            Spacer()

            Button(action: {
                self.isShowingAddEditTimelineItemView.toggle()
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
            .fullScreenCover(isPresented: $isShowingAddEditTimelineItemView, content: {
                AddFirstTimelineItemView().environment(\.managedObjectContext, moc)
            })
        }
    }
}
