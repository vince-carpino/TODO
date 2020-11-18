//
//  AddEditTimelineItemView.swift
//  TODO
//
//  Created by Vince Carpino on 9/25/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import SwiftUI

struct AddEditTimelineItemView: View {
    @Environment(\.presentationMode) var presentationMode

    let timeBlock: TimeBlock

    @State private var itemName: String = ""
    @State private var itemColor: Color = .white
    @State private var itemStartTime: Date = Date()
    @State private var itemEndTime: Date = Date()

    @State private var startTimeValue: Double = 1
    @State private var endTimeValue: Double = 2

    private let startEndTimeStep: Double = 1

    private let minimumStartHour: Double = 0
    private let maximumStartHour: Double = 23
    private let minimumEndHour: Double = 0
    private let maximumEndHour: Double = 23

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

                TimelineItem(timeBlock: timeBlock, name: $itemName, color: $itemColor, isPreview: true)
                    .disabled(true)
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

                    VStack(alignment: .leading, spacing: 8) {
                        ColorPicker(selectedColor: $itemColor)
                            .onAppear {
                                self.itemColor = self.timeBlock.color
                            }

                        Text("COLOR")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.clouds)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            let startTimeAtMinimum: Bool = startTimeValue == minimumStartHour
                            let startTimeAtMaximum: Bool = maximumStartHour - startTimeValue == startEndTimeStep

                            Button(action: {
                                if startTimeValue > minimumStartHour {
                                    startTimeValue -= startEndTimeStep
                                }
                            }) {
                                Image(systemName: "minus")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .frame(width: 75, height: 75)
                                    .foregroundColor(startTimeAtMinimum ? Color.clouds.opacity(0.25) : .clouds)
                                    .background(startTimeAtMinimum ? Color.alizarin.opacity(0.25) : Color.alizarin)
                                    .cornerRadius(10)
                            }
                            .disabled(startTimeAtMinimum)

                            Spacer()

                            Text("\(Double.getHour(startTimeValue))")
                                .font(.system(size: 30, weight: .semibold, design: .rounded))
                                .foregroundColor(.clouds)
                                .onAppear {
                                    startTimeValue = timeBlock.startTime
                                }

                            Spacer()

                            Button(action: {
                                if maximumStartHour - startTimeValue > startEndTimeStep {
                                    startTimeValue += startEndTimeStep

                                    if startTimeValue == endTimeValue {
                                        endTimeValue += startEndTimeStep
                                    }
                                }
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .frame(width: 75, height: 75)
                                    .foregroundColor(startTimeAtMaximum ? Color.clouds.opacity(0.25) : .clouds)
                                    .background(startTimeAtMaximum ? Color.greenSea.opacity(0.25) : Color.greenSea)
                                    .cornerRadius(10)
                            }
                            .disabled(startTimeAtMaximum)
                        }

                        Text("START TIME")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.clouds)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            let endTimeAtMinimum: Bool = endTimeValue - minimumStartHour == startEndTimeStep
                            let endTimeAtMaximum: Bool = endTimeValue == maximumStartHour

                            Button(action: {
                                if endTimeValue - minimumEndHour > startEndTimeStep {
                                    endTimeValue -= startEndTimeStep

                                    if endTimeValue == startTimeValue {
                                        startTimeValue -= startEndTimeStep
                                    }
                                }
                            }) {
                                Image(systemName: "minus")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .frame(width: 75, height: 75)
                                    .foregroundColor(endTimeAtMinimum ? Color.clouds.opacity(0.25) : .clouds)
                                    .background(endTimeAtMinimum ? Color.alizarin.opacity(0.25) : Color.alizarin)
                                    .cornerRadius(10)
                            }
                            .disabled(endTimeAtMinimum)

                            Spacer()

                            Text("\(Double.getHour(endTimeValue))")
                                .font(.system(size: 30, weight: .semibold, design: .rounded))
                                .foregroundColor(.clouds)
                                .onAppear {
                                    endTimeValue = timeBlock.endTime
                                }

                            Spacer()

                            Button(action: {
                                if endTimeValue < maximumEndHour {
                                    endTimeValue += startEndTimeStep
                                }
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .frame(width: 75, height: 75)
                                    .foregroundColor(endTimeAtMaximum ? Color.clouds.opacity(0.25) : .clouds)
                                    .background(endTimeAtMaximum ? Color.greenSea.opacity(0.25) : Color.greenSea)
                                    .cornerRadius(10)
                            }
                            .disabled(endTimeAtMaximum)
                        }

                        Text("END TIME")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.clouds)
                    }
                }
                .padding()

                VStack {
                    Button(action: {
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
                    .disabled(self.nameFieldIsEmpty())
                }
                .padding()
            }
        }
    }

    fileprivate func nameFieldIsEmpty() -> Bool {
        let textFieldToWatch = itemName
        return textFieldToWatch.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

struct AddEditTimelineItemView_Previews: PreviewProvider {
    static var previews: some View {
        let shortTimeBlock: TimeBlock = TimeBlock(name: "short", color: .purple, startTime: 8, endTime: 9)
        let longTimeBlock: TimeBlock = TimeBlock(name: "long", color: .purple, startTime: 8, endTime: 12)

        return Group {
            AddEditTimelineItemView(timeBlock: shortTimeBlock)

            AddEditTimelineItemView(timeBlock: longTimeBlock)
        }
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
