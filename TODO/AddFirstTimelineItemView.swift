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

    private let startEndTimeStep: Float = 0.5

    @State private var minimumStartHour: Float = 0
    @State private var maximumStartHour: Float = 23.5
    @State private var minimumEndHour: Float = 0.5
    @State private var maximumEndHour: Float = 24

    var saveButtonColor: Color {
        return nameFieldIsEmpty || colorNotChosen ? .concrete : .peterRiver
    }

    var colorNotChosen: Bool {
        return itemColor == .unusedTimeBlockColor
    }

    var nameFieldIsEmpty: Bool {
        let textFieldToWatch = itemName
        return textFieldToWatch.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        ZStack {
            BackgroundView()

            VStack {
                Text("ADD ITEM")
                    .bold()
                    .formatted(fontSize: 45)
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
                            let startTimeAtMinimum: Bool = startTimeValue == minimumStartHour
                            let startTimeAtMaximum: Bool = startTimeValue == maximumStartHour

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
                            let endTimeAtMinimum: Bool = endTimeValue == minimumEndHour
                            let endTimeAtMaximum: Bool = endTimeValue == maximumEndHour

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
                    Button(action: dismissSheet) {
                        HStack {
                            Image(systemName: "xmark")

                            Text("CANCEL")
                        }
                        .formatted(fontSize: 20)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .overlay(RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.asbestos, lineWidth: 5)
                        )
                        .cornerRadius(40)
                    }

                    Button(action: saveTimeBlockAndDismissSheet) {
                        HStack {
                            Image(systemName: "plus")

                            Text("SAVE")
                        }
                        .formatted(fontSize: 20)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(saveButtonColor)
                        .cornerRadius(40)
                    }
                    .disabled(nameFieldIsEmpty || colorNotChosen)
                }
                .padding()
            }
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
