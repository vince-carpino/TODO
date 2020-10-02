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
    @State private var itemStartTime: Date = Date()
    @State private var itemEndTime: Date = Date()

    @State private var startTimeValue: Double = 1
    @State private var endTimeValue: Double = 1

    var saveButtonColor: Color {
        return self.nameFieldIsEmpty() ? .concrete : .peterRiver
    }

    var body: some View {
        ZStack {
            BackgroundView()

            VStack {
                Text("ADD ITEM")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                    .foregroundColor(.clouds)
                    .bold()
                    .padding(.bottom, 15)

                Spacer()

                TimelineItem(timeBlock: timeBlock)
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
                        ColorPicker()

                        Text("COLOR")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.clouds)
                    }

                    VStack {
                        VStack(alignment: .leading) {
                            Slider(value: $startTimeValue, in: 1...12, step: 1)

                            Text("START TIME: \(Int(startTimeValue))")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.clouds)
                        }

                        VStack(alignment: .leading) {
                            Slider(value: $endTimeValue, in: 1...12, step: 1)

                            Text("END TIME: \(Int(endTimeValue))")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.clouds)
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
        let textFieldToWatch = self.itemName
        return textFieldToWatch.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

struct AddEditTimelineItemView_Previews: PreviewProvider {
    static var previews: some View {
        let timeblock: TimeBlock = TimeBlock(name: "name", color: .red, startTime: 8, endTime: 9)

        return AddEditTimelineItemView(timeBlock: timeblock)
    }
}

struct ColorPicker: View {
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
                Button(action: {}) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(color)

                        if color == .red {
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
