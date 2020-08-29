//
//  TimelineView.swift
//  TODO
//
//  Created by Vince Carpino on 8/21/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import SwiftUI

struct TimelineView: View {
    private var itemNames: [String] = [
        "some item",
        "another thing to do",
        "work",
        "lunch",
        "work",
        "learning session",
        "workout",
        "edit photos",
        "house projects",
        "tomorrow prep",
        "some item",
        "another thing to do with a long name",
        "work",
        "lunch",
        "work",
        "learning session",
        "workout",
        "edit photos",
        "house projects",
        "tomorrow prep",
        "some item",
        "another thing to do",
        "work",
        "lunch",
        "work",
        "learning session",
        "workout",
        "edit photos",
        "house projects",
        "tomorrow prep",
    ]
    private var colors: [Color] = [
        .red,
        .orange,
        .yellow,
        .green,
        .blue,
        .purple,
        .pink,
        .black,
        .gray,
        .midnightBlue,
        .red,
        .orange,
        .yellow,
        .green,
        .blue,
        .purple,
        .pink,
        .black,
        .gray,
        .midnightBlue,
        .red,
        .orange,
        .yellow,
        .green,
        .blue,
        .purple,
        .pink,
        .black,
        .gray,
        .midnightBlue,
    ]

    var body: some View {
        ZStack {
            Color.midnightBlue
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("TODAY")
                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                    .foregroundColor(.clouds)

                ScrollView(showsIndicators: false) {
                    ZStack {
                        VStack(spacing: 0) {
                            ForEach(0..<24) { index in
                                TimelineSeparator(hour: index)

                                HStack {
                                    Spacer()
                                        .frame(width: 50)

                                    TimelineItem(itemName: self.itemNames[index], itemColor: self.colors[index])
                                }
                            }

                            Spacer()
                        }
//                        .frame(maxWidth: .infinity)
//                        .padding()

//                        VStack(spacing: 0) {
//                            Spacer()
//                                .frame(height: 20)
//
//                            ForEach(0..<23) { index in
//                                HStack {
//                                    Spacer()
//                                        .frame(width: 50)
//                                    TimelineItem(itemName: self.itemNames[index], itemColor: self.colors[index])
//                                }
//
//                                Spacer()
//                                    .frame(height: 4)
//                            }
//
//                            Spacer()
//                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            }
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}

struct TimelineItem: View {
    var itemName: String
    var itemColor: Color

    private let cornerRadius: CGFloat = 5

    var body: some View {
        Button(action: {}) {
            HStack {
                Text(itemName.uppercased())
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .bold()
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .frame(maxWidth: .infinity, minHeight: 70, maxHeight: 70)
            .padding(10)
            .foregroundColor(.clouds)
            .background(itemColor)
            .cornerRadius(self.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .strokeBorder(Color.clouds, lineWidth: 3)
            )
        }
    }
}

struct TimelineSeparator: View {
    var hour: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(getHour(hourPastMidnight: hour))
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(.clouds)

            Divider()
                .background(Color.clouds)
        }
        .clipped(antialiased: false)
        .frame(height: 1)
        .offset(x: 0, y: -9)
    }

    func getHour(hourPastMidnight: Int) -> String {
        let amPm = hourPastMidnight < 12 ? "AM" : "PM"
        var hourNumber = hourPastMidnight

        if hourPastMidnight == 0 || hourPastMidnight == 12 {
            hourNumber = 12
        } else if hourPastMidnight > 12 {
            hourNumber = hourPastMidnight - 12
        }

        return "\(hourNumber) \(amPm)"
    }
}
