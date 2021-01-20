//
//  AddEditTimelineItemView.swift
//  TODO
//
//  Created by Vince Carpino on 9/25/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import SwiftUI

struct AddEditTimelineItemView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

//    let timeBlock: TimeBlock
    let storedTimeBlock: StoredTimeBlock?

    @State private var itemName: String = ""
    @State private var itemColor: Color = .white
    @State private var itemStartTime: Date = Date()
    @State private var itemEndTime: Date = Date()

    @State private var startTimeValue: Float = 1
    @State private var endTimeValue: Float = 2

    private let startEndTimeStep: Float = 0.5

    @State private var minimumStartHour: Float = 0
    @State private var maximumStartHour: Float = 23
    @State private var minimumEndHour: Float = 0
    @State private var maximumEndHour: Float = 23

    var saveButtonColor: Color {
        return nameFieldIsEmpty() || colorNotChosen() ? .concrete : .peterRiver
    }

    var body: some View {
        ZStack {
            BackgroundView()

            VStack {
                Text("\(isNewItem() ? "ADD" : "EDIT") ITEM")
                    .font(.system(size: 45, weight: .semibold, design: .rounded))
                    .foregroundColor(.clouds)
                    .bold()
                    .padding()

                TimelineItemPreview(name: $itemName, color: $itemColor)
                    .padding()

                Spacer()

                Divider()
                    .background(Color.clouds)

                VStack(spacing: 25) {
                    VStack(alignment: .leading) {
                        ZStack(alignment: .leading) {
                            if itemName.isEmpty {
                                Text("Enter a name...")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .padding(.leading, 10)
                                    .foregroundColor(Color.clouds.opacity(0.25))
                            }
                            TextField("", text: $itemName)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .padding(10)
                                .foregroundColor(.clouds)
                                .background(Color.black.opacity(0.25))
                                .cornerRadius(5)
                                .onAppear {
                                    self.itemName = self.storedTimeBlock?.name ?? ""
//                                    self.itemName = self.timeBlock.name
                                }
                        }

                        Text("NAME")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.clouds)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        ColorPicker(selectedColor: $itemColor)
                            .onAppear {
                                self.itemColor = getColorFromColorName()
//                                self.itemColor = self.timeBlock.color
                            }

                        Text("COLOR")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.clouds)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            let startTimeAtMinimum: Bool = startTimeValue == minimumStartHour
                            let startTimeAtMaximum: Bool = startTimeValue == maximumStartHour

                            StartEndTimeDecreaseButton(action: decreaseStartTime, isTargetTimeAtMinimum: startTimeAtMinimum)

                            Spacer()

                            Text("\(Float.getHour(startTimeValue))")
                                .font(.system(size: 30, weight: .semibold, design: .rounded))
                                .foregroundColor(.clouds)
                                .onAppear {
                                    startTimeValue = storedTimeBlock?.startTime ?? 8
//                                    startTimeValue = timeBlock.startTime
                                }

                            Spacer()

                            StartEndTimeIncreaseButton(action: increaseStartTime, isTargetTimeAtMaximum: startTimeAtMaximum)
                        }

                        Text("START TIME")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.clouds)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            let endTimeAtMinimum: Bool = endTimeValue == minimumEndHour
                            let endTimeAtMaximum: Bool = endTimeValue == maximumEndHour

                            StartEndTimeDecreaseButton(action: decreaseEndTime, isTargetTimeAtMinimum: endTimeAtMinimum)

                            Spacer()

                            Text("\(Float.getHour(endTimeValue))")
                                .font(.system(size: 30, weight: .semibold, design: .rounded))
                                .foregroundColor(.clouds)
                                .onAppear {
                                    endTimeValue = storedTimeBlock?.endTime ?? 9
//                                    endTimeValue = timeBlock.endTime
                                }

                            Spacer()

                            StartEndTimeIncreaseButton(action: increaseEndTime, isTargetTimeAtMaximum: endTimeAtMaximum)
                        }

                        Text("END TIME")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.clouds)
                    }
                }
                .padding()

                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "xmark")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))

                            Text("CANCEL")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                        }
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(.clouds)
                        .overlay(RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.asbestos, lineWidth: 5)
                        )
                        .cornerRadius(40)
                    }

                    Button(action: {
                        // SAVE TO CORE DATA
                        if isNewItem() {
                            // create new StoredTimeBlock
                        } else {
                            // save StoredTimeBlock that was passsed in
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))

                            Text("SAVE")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                        }
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(.clouds)
                        .background(saveButtonColor)
                        .cornerRadius(40)
                    }
                    .disabled(self.nameFieldIsEmpty() || colorNotChosen())
                }
                .padding()
            }
        }
        .onAppear {
            self.minimumStartHour = storedTimeBlock?.startTime ?? 8
//            self.minimumStartHour = timeBlock.startTime
            self.minimumEndHour = self.minimumStartHour + startEndTimeStep

            self.maximumEndHour = storedTimeBlock?.endTime ?? 9
//            self.maximumEndHour = timeBlock.endTime
            self.maximumStartHour = self.maximumEndHour - startEndTimeStep
        }
    }

    fileprivate func isNewItem() -> Bool {
        return storedTimeBlock?.isUnused ?? true
//        return timeBlock is UnusedTimeBlock
    }

    func getColorFromColorName() -> Color {
        return Color.coreDataLegend.someKey(forValue: storedTimeBlock?.colorName ?? "clear") ?? .clear
    }

    fileprivate func colorNotChosen() -> Bool {
        return itemColor == .unusedTimeBlockColor
    }

    fileprivate func nameFieldIsEmpty() -> Bool {
        let textFieldToWatch = itemName
        return textFieldToWatch.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    fileprivate func decreaseStartTime() {
        if startTimeValue != minimumStartHour {
            startTimeValue -= startEndTimeStep
        }
    }

    fileprivate func increaseStartTime() {
        if startTimeValue != maximumStartHour {
            startTimeValue += startEndTimeStep

            if startTimeValue == endTimeValue {
                endTimeValue += startEndTimeStep
            }
        }
    }

    fileprivate func decreaseEndTime() {
        if endTimeValue != minimumEndHour {
            endTimeValue -= startEndTimeStep

            if endTimeValue == startTimeValue {
                startTimeValue -= startEndTimeStep
            }
        }
    }

    fileprivate func increaseEndTime() {
        if endTimeValue != maximumEndHour {
            endTimeValue += startEndTimeStep
        }
    }

    fileprivate func addNewStoredTimeBlock() {
        let storedTimeBlock = StoredTimeBlock(context: self.moc)
        storedTimeBlock.id = UUID()
        storedTimeBlock.name = self.itemName
        storedTimeBlock.colorName = Color.coreDataLegend[self.itemColor]
        storedTimeBlock.startTime = self.startTimeValue
        storedTimeBlock.endTime = self.endTimeValue

        self.saveContext()
    }

    fileprivate func saveContext() {
        do {
            try self.moc.save()
        } catch {
            print("Error while saving item:\n***\n\(error)\n***")
        }
    }

    fileprivate func saveItem() {
//        self.moc.performAndWait {
//            self.timeBlock.name = self.itemName
//            self.timeBlock.color
//
//            saveContext()
//        }
    }
}

struct AddEditTimelineItemView_Previews: PreviewProvider {
    static var previews: some View {
//        let shortTimeBlock: TimeBlock = TimeBlock(name: "short", color: .purple, startTime: 8, endTime: 9)
//        let longTimeBlock: TimeBlock = TimeBlock(name: "long", color: .purple, startTime: 8, endTime: 12)

        AddEditTimelineItemView(storedTimeBlock: nil)
//        AddEditTimelineItemView(timeBlock: shortTimeBlock)

//        AddEditTimelineItemView(timeBlock: longTimeBlock)
    }
}

struct ColorPicker: View {
    @Binding var selectedColor: Color

    private let colors: [Color] = [
        .red,
        .orange,
        .yellow,
        .green,
        .blue,
        .purple,
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(colors, id: \.self) { color in
                Button(action: {
                    selectedColor = color
                }) {
                    ZStack {
                        if color == selectedColor {
                            Rectangle()
                                .foregroundColor(color)
                                .overlay(Rectangle()
                                    .strokeBorder(Color.clouds, lineWidth: 4))
                        } else {
                            Rectangle()
                                .foregroundColor(color)
                        }

                        if color == selectedColor {
                            Image(systemName: "checkmark")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.clouds)
                        }
                    }
                }
            }
        }
        .frame(height: 50)
        .cornerRadius(5)
    }
}

struct StartEndTimeDecreaseButton: View {
    var action: () -> Void
    var isTargetTimeAtMinimum: Bool

    var body: some View {
        Button(action: action) {
            Image(systemName: "minus")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .frame(width: 75, height: 75)
                .foregroundColor(isTargetTimeAtMinimum ? Color.clouds.opacity(0.25) : .clouds)
                .background(isTargetTimeAtMinimum ? Color.alizarin.opacity(0.25) : Color.alizarin)
                .cornerRadius(10)
        }
        .disabled(isTargetTimeAtMinimum)
    }
}

struct StartEndTimeIncreaseButton: View {
    var action: () -> Void
    var isTargetTimeAtMaximum: Bool

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .frame(width: 75, height: 75)
                .foregroundColor(isTargetTimeAtMaximum ? Color.clouds.opacity(0.25) : .clouds)
                .background(isTargetTimeAtMaximum ? Color.greenSea.opacity(0.25) : .greenSea)
                .cornerRadius(10)
        }
        .disabled(isTargetTimeAtMaximum)
    }
}
