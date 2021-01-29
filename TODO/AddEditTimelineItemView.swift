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

    let storedTimeBlock: StoredTimeBlock

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
                Text("\(storedTimeBlock.isUnused ? "ADD" : "EDIT") ITEM")
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
                                    self.itemName = self.storedTimeBlock.name ?? ""
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

                            Text("\(TimelineSeparator.getHour(hourPastMidnight: startTimeValue))")
                                .font(.system(size: 30, weight: .semibold, design: .rounded))
                                .foregroundColor(.clouds)
                                .onAppear {
                                    startTimeValue = storedTimeBlock.startTime
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

                            Text("\(TimelineSeparator.getHour(hourPastMidnight: endTimeValue))")
                                .font(.system(size: 30, weight: .semibold, design: .rounded))
                                .foregroundColor(.clouds)
                                .onAppear {
                                    endTimeValue = storedTimeBlock.endTime
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
                        saveTimeBlock()

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
            self.minimumStartHour = storedTimeBlock.startTime
            self.minimumEndHour = self.minimumStartHour + startEndTimeStep

            self.maximumEndHour = storedTimeBlock.endTime
            self.maximumStartHour = self.maximumEndHour - startEndTimeStep
        }
    }

    func getColorFromColorName() -> Color {
        return Color.coreDataLegend.someKey(forValue: storedTimeBlock.colorName ?? "clear") ?? .clear
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

    fileprivate func saveContext() {
        do {
            try moc.save()
        } catch {
            print("Error while saving item:\n***\n\(error)\n***")
        }
    }

    fileprivate func saveTimeBlock() {
        moc.performAndWait {
            self.storedTimeBlock.name = self.itemName
            self.storedTimeBlock.colorName = Color.coreDataLegend[self.itemColor]
            self.storedTimeBlock.startTime = self.startTimeValue
            self.storedTimeBlock.endTime = self.endTimeValue

            saveContext()
        }
    }
}

struct AddEditTimelineItemView_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let timeBlockToAdd = StoredTimeBlock(context: moc)
        timeBlockToAdd.id = UUID()
        timeBlockToAdd.name = ""
        timeBlockToAdd.colorName = "clear"
        timeBlockToAdd.startTime = 1
        timeBlockToAdd.endTime = 23
        timeBlockToAdd.isUnused = false

        return AddEditTimelineItemView(storedTimeBlock: timeBlockToAdd).environment(\.managedObjectContext, moc)
    }
}

struct AddFirstTimelineItemView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    @State private var itemName: String = ""
    @State private var itemColor: Color = .defaultTimeBlockColor
    @State private var itemStartTime: Date = Date()
    @State private var itemEndTime: Date = Date()

    @State private var startTimeValue: Float = 8
    @State private var endTimeValue: Float = 9

    private let startEndTimeStep: Float = 0.5

    @State private var minimumStartHour: Float = 0
    @State private var maximumStartHour: Float = 23.5
    @State private var minimumEndHour: Float = 0.5
    @State private var maximumEndHour: Float = 24

    var saveButtonColor: Color {
        return nameFieldIsEmpty() || colorNotChosen() ? .concrete : .peterRiver
    }

    var body: some View {
        ZStack {
            BackgroundView()

            VStack {
                Text("ADD ITEM")
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
                        }

                        Text("NAME")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.clouds)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        ColorPicker(selectedColor: $itemColor)

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

                            Text("\(TimelineSeparator.getHour(hourPastMidnight: startTimeValue))")
                                .font(.system(size: 30, weight: .semibold, design: .rounded))
                                .foregroundColor(.clouds)

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

                            Text("\(TimelineSeparator.getHour(hourPastMidnight: endTimeValue))")
                                .font(.system(size: 30, weight: .semibold, design: .rounded))
                                .foregroundColor(.clouds)

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
                        addNewStoredTimeBlock()

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
        moc.performAndWait {
            let timeBlockToStore = StoredTimeBlock(context: moc)
            timeBlockToStore.id = UUID()
            timeBlockToStore.name = itemName
            timeBlockToStore.colorName = Color.coreDataLegend[itemColor]
            timeBlockToStore.startTime = startTimeValue
            timeBlockToStore.endTime = endTimeValue
            timeBlockToStore.isUnused = false

            saveContext()
        }
    }

    fileprivate func saveContext() {
        do {
            try moc.save()
        } catch {
            print("Error while saving item:\n***\n\(error)\n***")
        }
    }
}

struct ColorPicker: View {
    @Binding var selectedColor: Color

    private let colors: [Color] = [
        .alizarin,
        .carrot,
        .sunFlower,
        .nephritis,
        .peterRiver,
        .amethyst,
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
