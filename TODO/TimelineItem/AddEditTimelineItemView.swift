import SwiftUI

struct AddEditTimelineItemView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    @FetchRequest(entity: StoredTimeBlock.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \StoredTimeBlock.startTime, ascending: true),
    ]) var timeBlocksCoreData: FetchedResults<StoredTimeBlock>

    let storedTimeBlock: StoredTimeBlock

    @State private var previousTimeBlock: StoredTimeBlock? = nil
    @State private var nextTimeBlock: StoredTimeBlock? = nil

    @State private var itemName: String = ""
    @State private var itemColor: Color = .white
    @State private var itemStartTime: Date = Date()
    @State private var itemEndTime: Date = Date()

    @State private var startTimeValue: Float = 1
    @State private var endTimeValue: Float = 2

    @State private var minimumStartHour: Float = 0
    @State private var maximumStartHour: Float = 23
    @State private var minimumEndHour: Float = 0
    @State private var maximumEndHour: Float = 23

    var colorNotChosen: Bool {
        return itemColor == .unusedTimeBlockColor
    }

    var nameFieldIsEmpty: Bool {
        return itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var saveButtonDisabled: Bool {
        return nameFieldIsEmpty || colorNotChosen
    }

    var saveButtonColor: Color {
        return nameFieldIsEmpty || colorNotChosen ? .concrete : .peterRiver
    }

    var endTimeIsMidnight: Bool {
        return endTimeValue == 24
    }

    var titleText: String {
        return "\(storedTimeBlock.isUnused ? "Add" : "Edit") Item"
    }

    var startTimeAtMinimum: Bool {
        return startTimeValue == minimumStartHour
    }

    var startTimeAtMaximum: Bool {
        return startTimeValue == maximumStartHour
    }

    var endTimeAtMinimum: Bool {
        return endTimeValue == minimumEndHour
    }

    var endTimeAtMaximum: Bool {
        return endTimeValue == maximumEndHour
    }

    var body: some View {
        ZStack {
            BackgroundView()

            VStack {
                TitleView(text: titleText)

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
                                .onAppear {
                                    itemName = storedTimeBlock.name ?? ""
                                }
                        }

                        Text("NAME")
                            .formatted(fontSize: 14)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        ColorPicker(selectedColor: $itemColor)
                            .onAppear {
                                itemColor = getColor(colorName: storedTimeBlock.colorName)
                            }

                        Text("COLOR")
                            .formatted(fontSize: 14)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            StartEndTimeDecreaseButton(action: decreaseStartTime, isTargetTimeAtMinimum: startTimeAtMinimum)

                            Spacer()

                            Text("\(TimelineSeparator.getHour(hourPastMidnight: startTimeValue))")
                                .formatted(fontSize: 30)
                                .onAppear {
                                    startTimeValue = storedTimeBlock.startTime
                                }

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

                            VStack {
                                Text("\(TimelineSeparator.getHour(hourPastMidnight: endTimeValue))")
                                    .formatted(fontSize: 30)
                                    .onAppear {
                                        endTimeValue = storedTimeBlock.endTime
                                    }

                                if endTimeIsMidnight {
                                    Text("NEXT DAY")
                                        .formatted(fontSize: 16)
                                }
                            }

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

                    AddEditSaveButton(action: saveTimeBlockAndDismissSheet, backgroundColor: saveButtonColor, disabledCondition: saveButtonDisabled)
                }
                .padding()
            }
        }
        .onAppear {
            determineMinimumStartHour()
            minimumEndHour = minimumStartHour + Constants.startEndTimeStep

            determineMaximumEndHour()
            maximumStartHour = maximumEndHour - Constants.startEndTimeStep
        }
    }

    func getColor(colorName: String?) -> Color {
        return Color.coreDataLegend.someKey(forValue: colorName ?? "clear") ?? .clear
    }

    fileprivate func determineMinimumStartHour() {
        let previousTimeBlockIndex = timeBlocksCoreData.firstIndex(of: storedTimeBlock)! - 1
        if timeBlocksCoreData.indices.contains(previousTimeBlockIndex) {
            previousTimeBlock = timeBlocksCoreData[previousTimeBlockIndex]
            if previousTimeBlock != nil, previousTimeBlock!.isUnused {
                minimumStartHour = previousTimeBlock!.startTime
            } else {
                minimumStartHour = storedTimeBlock.startTime
            }
        }
    }

    fileprivate func determineMaximumEndHour() {
        let nextTimeBlockIndex = timeBlocksCoreData.firstIndex(of: storedTimeBlock)! + 1
        if timeBlocksCoreData.indices.contains(nextTimeBlockIndex) {
            nextTimeBlock = timeBlocksCoreData[nextTimeBlockIndex]
            if nextTimeBlock != nil, nextTimeBlock!.isUnused {
                maximumEndHour = nextTimeBlock!.endTime
            } else {
                maximumEndHour = storedTimeBlock.endTime
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

    fileprivate func saveContext() {
        do {
            try moc.save()
        } catch {
            print("Error while saving item:\n***\n\(error)\n***")
        }
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

    fileprivate func configurePreviousTimeBlock() {
        if previousTimeBlock == nil { return }

        if storedTimeBlock == timeBlocksCoreData.first, storedTimeBlock.startTime != Constants.startOfDayHour {
            createUnusedTimeBlock(startTime: Constants.startOfDayHour, endTime: storedTimeBlock.startTime)
        } else if storedTimeBlock.startTime == previousTimeBlock!.startTime {
            moc.delete(previousTimeBlock!)
        } else if storedTimeBlock.startTime != previousTimeBlock!.endTime, previousTimeBlock!.isUnused {
            previousTimeBlock!.endTime = storedTimeBlock.startTime
        } else if !previousTimeBlock!.isUnused, previousTimeBlock!.endTime != storedTimeBlock.startTime {
            createUnusedTimeBlock(startTime: previousTimeBlock!.endTime, endTime: storedTimeBlock.startTime)
        }
    }

    fileprivate func configureNextTimeBlock() {
        if nextTimeBlock == nil { return }

        if storedTimeBlock == timeBlocksCoreData.last, storedTimeBlock.endTime != Constants.endOfDayHour {
            createUnusedTimeBlock(startTime: storedTimeBlock.endTime, endTime: Constants.endOfDayHour)
        } else if storedTimeBlock.endTime == nextTimeBlock!.endTime {
            moc.delete(nextTimeBlock!)
        } else if storedTimeBlock.endTime != nextTimeBlock!.startTime, nextTimeBlock!.isUnused {
            nextTimeBlock!.startTime = storedTimeBlock.endTime
        } else if !nextTimeBlock!.isUnused, nextTimeBlock!.startTime != storedTimeBlock.endTime {
            createUnusedTimeBlock(startTime: storedTimeBlock.endTime, endTime: nextTimeBlock!.startTime)
        }
    }

    fileprivate func saveTimeBlock() {
        moc.performAndWait {
            storedTimeBlock.name = itemName
            storedTimeBlock.colorName = Color.coreDataLegend[itemColor]
            storedTimeBlock.startTime = startTimeValue
            storedTimeBlock.endTime = endTimeValue
            storedTimeBlock.isUnused = false

            configurePreviousTimeBlock()

            configureNextTimeBlock()

            saveContext()
        }
    }

    fileprivate func saveTimeBlockAndDismissSheet() {
        saveTimeBlock()

        dismissSheet()
    }

    func dismissSheet() {
        presentationMode.wrappedValue.dismiss()
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
        timeBlockToAdd.endTime = 24
        timeBlockToAdd.isUnused = false

        return AddEditTimelineItemView(storedTimeBlock: timeBlockToAdd).environment(\.managedObjectContext, moc)
    }
}
