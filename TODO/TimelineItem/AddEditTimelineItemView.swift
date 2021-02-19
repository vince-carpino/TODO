import SwiftUI

struct AddEditTimelineItemView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    @FetchRequest(entity: StoredTimeBlock.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \StoredTimeBlock.startTime, ascending: true),
    ]) var timeBlocksCoreData: FetchedResults<StoredTimeBlock>

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

    var colorNotChosen: Bool {
        return itemColor == .unusedTimeBlockColor
    }

    var nameFieldIsEmpty: Bool {
        return itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
                            let startTimeAtMinimum: Bool = startTimeValue == minimumStartHour
                            let startTimeAtMaximum: Bool = startTimeValue == maximumStartHour

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
                            let endTimeAtMinimum: Bool = endTimeValue == minimumEndHour
                            let endTimeAtMaximum: Bool = endTimeValue == maximumEndHour

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

                    AddEditSaveButton(action: saveTimeBlockAndDismissSheet, backgroundColor: saveButtonColor, disabledCondition: nameFieldIsEmpty || colorNotChosen)
                }
                .padding()
            }
        }
        .onAppear {
            determineMinimumStartHour()
            minimumEndHour = minimumStartHour + startEndTimeStep

            determineMaximumEndHour()
            maximumStartHour = maximumEndHour - startEndTimeStep
        }
    }

    func getColor(colorName: String?) -> Color {
        return Color.coreDataLegend.someKey(forValue: colorName ?? "clear") ?? .clear
    }

    fileprivate func determineMinimumStartHour() {
        let previousTimeBlockIndex = timeBlocksCoreData.firstIndex(of: storedTimeBlock)! - 1
        if previousTimeBlockIndex >= 0 {
            let previousTimeBlock = timeBlocksCoreData[previousTimeBlockIndex]
            if previousTimeBlock.isUnused {
                minimumStartHour = previousTimeBlock.startTime
            }
        }
    }

    fileprivate func determineMaximumEndHour() {
        let nextTimeBlockIndex = timeBlocksCoreData.firstIndex(of: storedTimeBlock)! + 1
        if timeBlocksCoreData.indices.contains(nextTimeBlockIndex), timeBlocksCoreData[nextTimeBlockIndex].isUnused {
            let nextTimeBlock = timeBlocksCoreData[nextTimeBlockIndex]
            maximumEndHour = nextTimeBlock.endTime
        }
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

            storedTimeBlock.name = itemName
            storedTimeBlock.colorName = Color.coreDataLegend[itemColor]
            storedTimeBlock.startTime = startTimeValue
            storedTimeBlock.endTime = endTimeValue
            storedTimeBlock.isUnused = false

            saveContext()
    fileprivate func saveTimeBlockAndDismissSheet() {
        saveTimeBlock()

        dismissSheet()
    }

    func dismissSheet() {
        presentationMode.wrappedValue.dismiss()
    }

    fileprivate func fillEmptyTimelineSpaces(firstTimeBlock: StoredTimeBlock) {
        let startOfDayHour: Float = 8
        let endOfDayHour: Float = 24

        if firstTimeBlock.startTime != startOfDayHour {
            let filler = StoredTimeBlock(context: moc)
            filler.id = UUID()
            filler.name = ""
            filler.colorName = "clear"
            filler.startTime = startOfDayHour
            filler.endTime = firstTimeBlock.startTime
            filler.isUnused = true
        }

        if firstTimeBlock.endTime != endOfDayHour {
            let filler = StoredTimeBlock(context: moc)
            filler.id = UUID()
            filler.name = ""
            filler.colorName = "clear"
            filler.startTime = firstTimeBlock.endTime
            filler.endTime = endOfDayHour
            filler.isUnused = true
        }

                }

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
        timeBlockToAdd.endTime = 24
        timeBlockToAdd.isUnused = false

        return AddEditTimelineItemView(storedTimeBlock: timeBlockToAdd).environment(\.managedObjectContext, moc)
    }
}
