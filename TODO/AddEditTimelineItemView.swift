//
//  AddEditTimelineItemView.swift
//  TODO
//
//  Created by Vince Carpino on 9/25/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import SwiftUI

struct AddEditTimelineItemView: View {
    let timeBlock: TimeBlock

    @State private var itemName: String = ""
    @State private var itemColor: Color = .white
    @State private var itemStartTime: Date = Date()
    @State private var itemEndTime: Date = Date()

    @State private var startTimeValue: Double = 1
    @State private var endTimeValue: Double = 2
    @State private var startTimeAmPm: String = "AM"
    @State private var endTimeAmPm: String = "AM"

    private let amPmOptions = ["AM", "PM"]
    private let startEndTimeValues: ClosedRange<Double> = 1...12
    private let startEndTimeStep: Double = 1

    var saveButtonColor: Color {
        return nameFieldIsEmpty() ? .concrete : .peterRiver
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

                TimelineItem(timeBlock: timeBlock, name: $itemName, color: $itemColor)
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
                                    self.itemName = self.timeBlock.name
                                }
                        }

                        Text("NAME")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.clouds)
                    }

                    VStack(alignment: .leading) {
                        ColorPicker(selectedColor: $itemColor)
                            .onAppear {
                                self.itemColor = self.timeBlock.color
                            }

                        Text("COLOR")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.clouds)
                    }

                    VStack {
                        VStack(alignment: .leading) {
                            Slider(value: $startTimeValue, in: startEndTimeValues, step: startEndTimeStep) { isEditing in
                                if !isEditing {
                                    checkAndSetEndTime()
                                }
                            }
                            .onAppear {
                                startTimeValue = timeBlock.startTime
                            }

                            HStack {
                                Text("START TIME: \(Int(startTimeValue))")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(.clouds)

                                Spacer()

                                Picker(selection: $startTimeAmPm, label: Text("")) {
                                    ForEach(amPmOptions, id: \.self) { option in
                                        Text(option)
                                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(maxWidth: 125)
                            }
                        }

                        VStack(alignment: .leading) {
                            Slider(value: $endTimeValue, in: startEndTimeValues, step: startEndTimeStep) { isEditing in
                                if !isEditing {
                                    checkAndSetStartTime()
                                }
                            }
                            .onAppear {
                                endTimeValue = timeBlock.endTime
                            }

                            HStack {
                                Text("END TIME: \(Int(endTimeValue))")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(.clouds)

                                Spacer()

                                Picker(selection: $endTimeAmPm, label: Text("")) {
                                    ForEach(amPmOptions, id: \.self) { option in
                                        Text(option)
                                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(maxWidth: 125)
                            }
                        }
                    }
                }
                .padding()

                VStack {
                    Button(action: {}) {
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
                    .disabled(self.nameFieldIsEmpty())

                    Text("swipe down to cancel")
                        .foregroundColor(.silver)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
                .padding()
            }
        }
    }

    fileprivate func nameFieldIsEmpty() -> Bool {
        let textFieldToWatch = itemName
        return textFieldToWatch.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    fileprivate func checkAndSetStartTime() {
        if endTimeValue == startEndTimeValues.lowerBound {
            endTimeValue += startEndTimeStep
        }
        if endTimeValue <= startTimeValue {
            startTimeValue = endTimeValue - startEndTimeStep
        }
    }

    fileprivate func checkAndSetEndTime() {
        if startTimeValue == startEndTimeValues.upperBound {
            startTimeValue -= startEndTimeStep
        }
        if startTimeValue >= endTimeValue {
            endTimeValue = startTimeValue + startEndTimeStep
        }
    }
}

struct AddEditTimelineItemView_Previews: PreviewProvider {
    static var previews: some View {
        let timeblock: TimeBlock = TimeBlock(name: "name", color: .purple, startTime: 8, endTime: 9)

        return AddEditTimelineItemView(timeBlock: timeblock)
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
