//
//  TimelineSeparator.swift
//  TODO
//
//  Created by Vince Carpino on 1/29/21.
//  Copyright © 2021 Vince Carpino. All rights reserved.
//

import SwiftUI

struct TimelineSeparator: View {
    var hour: Float

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(TimelineSeparator.getHour(hourPastMidnight: hour))
                .formatted(fontSize: 15)

            Divider()
                .background(Color.clouds)
        }
        .clipped(antialiased: false)
        .frame(height: 1)
        .offset(x: 0, y: -9)
    }

    static func getHour(hourPastMidnight: Float) -> String {
        let amPm = hourPastMidnight < 12 || hourPastMidnight == 24 ? "AM" : "PM"
        let isPartialHour = floor(hourPastMidnight) != hourPastMidnight
        var hourNumber = floor(hourPastMidnight)

        if hourNumber == 0 {
            hourNumber = 12
        } else if hourNumber > 12 {
            hourNumber = hourPastMidnight - 12
        }

        if isPartialHour {
            let minutes = (hourPastMidnight - floor(hourPastMidnight)) * 60
            return "\(Int(hourNumber)):\(Int(minutes)) \(amPm)"
        }

        return "\(Int(hourNumber)) \(amPm)"
    }
}

struct TimelineSeparator_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()

            TimelineSeparator(hour: 8)
        }
    }
}
