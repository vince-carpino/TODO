import SwiftUI

struct AddFirstTimelineItemView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    @State private var itemName: String = ""
    @State private var itemColor: Color = .defaultTimeBlockColor
    @State private var itemStartTime: Date = Date()
    @State private var itemEndTime: Date = Date()

    @State private var startTimeValue: Float = 8
    @State private var endTimeValue: Float = 9

    @State private var minimumStartHour: Float = 0
    @State private var maximumStartHour: Float = 23.5
    @State private var minimumEndHour: Float = 0.5
    @State private var maximumEndHour: Float = 24

    var startTimeAtMinimum: Bool {
        return startTimeValue == minimumStartHour
    }

    var startTimeAtMaximum: Bool {
        startTimeValue == maximumStartHour
    }

    var endTimeAtMinimum: Bool {
        endTimeValue == minimumEndHour
    }

    var endTimeAtMaximum: Bool {
        endTimeValue == maximumEndHour
    }

    var saveButtonColor: Color {
        return nameFieldIsEmpty || colorNotChosen ? .concrete : .peterRiver
    }

    var colorNotChosen: Bool {
        return itemColor == .unusedTimeBlockColor
    }

    var nameFieldIsEmpty: Bool {
        return itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        ZStack {
            BackgroundView()

            VStack {
                TitleView(text: "Add Item")

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
                                    .formatted(fontSize: 20, foregroundColor: Color.clouds.opacity(0.25))
                                    .padding(.leading, 10)
                            }
                            TextField("", text: $itemName)
                                .formatted(fontSize: 20)
                                .padding(10)
                                .background(Color.black.opacity(0.25))
                                .cornerRadius(5)
                        }

                        Text("NAME")
                            .formatted(fontSize: 14)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        ColorPicker(selectedColor: $itemColor)

                        Text("COLOR")
                            .formatted(fontSize: 14)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            StartEndTimeDecreaseButton(action: decreaseStartTime, isTargetTimeAtMinimum: startTimeAtMinimum)

                            Spacer()

                            Text("\(TimelineSeparator.getHour(hourPastMidnight: startTimeValue))")
                                .formatted(fontSize: 30)

                            Spacer()

                            StartEndTimeIncreaseButton(action: increaseStartTime, isTargetTimeAtMaximum: startTimeAtMaximum)
                        }

                        Text("START TIME")
                            .formatted(fontSize: 14)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            StartEndTimeDecreaseButton(action: decreaseEndTime, isTargetTimeAtMinimum: endTimeAtMinimum)

                            Spacer()

                            Text("\(TimelineSeparator.getHour(hourPastMidnight: endTimeValue))")
                                .formatted(fontSize: 30)

                            Spacer()

                            StartEndTimeIncreaseButton(action: increaseEndTime, isTargetTimeAtMaximum: endTimeAtMaximum)
                        }

                        Text("END TIME")
                            .formatted(fontSize: 14)
                    }
                }
                .padding()

                HStack {
                    AddEditCancelButton(action: dismissSheet)

                    AddEditSaveButton(action: saveTimeBlockAndDismissSheet, backgroundColor: saveButtonColor, disabledCondition: nameFieldIsEmpty || colorNotChosen)
                }
                .padding()
            }
        }
    }

    fileprivate func decreaseStartTime() {
        if startTimeValue != minimumStartHour {
            startTimeValue -= Constants.startEndTimeStep
        }
    }

    fileprivate func increaseStartTime() {
        if startTimeValue != maximumStartHour {
            startTimeValue += Constants.startEndTimeStep

            if startTimeValue == endTimeValue {
                endTimeValue += Constants.startEndTimeStep
            }
        }
    }

    fileprivate func decreaseEndTime() {
        if endTimeValue != minimumEndHour {
            endTimeValue -= Constants.startEndTimeStep

            if endTimeValue == startTimeValue {
                startTimeValue -= Constants.startEndTimeStep
            }
        }
    }

    fileprivate func increaseEndTime() {
        if endTimeValue != maximumEndHour {
            endTimeValue += Constants.startEndTimeStep
        }
    }

    func dismissSheet() {
        presentationMode.wrappedValue.dismiss()
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

            fillEmptyTimelineSpaces(firstTimeBlock: timeBlockToStore)

            saveContext()
        }
    }

    func saveTimeBlockAndDismissSheet() {
        addNewStoredTimeBlock()

        dismissSheet()
    }

    fileprivate func createUnusedTimeBlock(startTime: Float, endTime: Float) {
        let newPreviousTimeBlock = StoredTimeBlock(context: moc)
        newPreviousTimeBlock.id = UUID()
        newPreviousTimeBlock.name = ""
        newPreviousTimeBlock.colorName = "clear"
        newPreviousTimeBlock.startTime = startTime
        newPreviousTimeBlock.endTime = endTime
        newPreviousTimeBlock.isUnused = true
    }

    fileprivate func fillEmptyTimelineSpaces(firstTimeBlock: StoredTimeBlock) {
        if firstTimeBlock.startTime != Constants.startOfDayHour {
            createUnusedTimeBlock(startTime: Constants.startOfDayHour, endTime: firstTimeBlock.startTime)
        }

        if firstTimeBlock.endTime != Constants.endOfDayHour {
            createUnusedTimeBlock(startTime: firstTimeBlock.endTime, endTime: Constants.endOfDayHour)
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

struct AddFirstTimelineItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddFirstTimelineItemView()
    }
}
