//
//  TimelineItem.swift
//  TODO
//
//  Created by Vince Carpino on 1/29/21.
//  Copyright © 2021 Vince Carpino. All rights reserved.
//

import SwiftUI

struct TimelineItem: View {
    @Environment(\.managedObjectContext) var moc
    @State private var isPresentingAddEditView = false

    @ObservedObject var storedTimeBlock: StoredTimeBlock

    private let cornerRadius: CGFloat = 5
    private let baseHeight: CGFloat = 70

    var body: some View {
        Button(action: {
            self.isPresentingAddEditView.toggle()
        }) {
            HStack {
                if self.storedTimeBlock.isUnused {
                    Image(systemName: "plus")
                }

                Text(storedTimeBlock.name?.uppercased() ?? "")
                    .bold()
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .formatted(fontSize: 20)
            .frame(maxWidth: .infinity, minHeight: calculateHeight(), maxHeight: calculateHeight())
            .padding(10)
            .background(getColorFromColorName())
            .cornerRadius(self.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .strokeBorder(Color.clouds, lineWidth: 5)
            )
        }
        .fullScreenCover(isPresented: $isPresentingAddEditView, content: {
            AddEditTimelineItemView(storedTimeBlock: storedTimeBlock).environment(\.managedObjectContext, moc)
        })
    }

    func calculateHeight() -> CGFloat {
        return CGFloat(storedTimeBlock.endTime - storedTimeBlock.startTime) * baseHeight
    }

    func getColorFromColorName() -> Color {
        return Color.coreDataLegend.someKey(forValue: storedTimeBlock.colorName ?? "clear") ?? .clear
    }
}

struct TimelineItem_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let storedTimeBlock = StoredTimeBlock(context: moc)
        storedTimeBlock.name = "First thing"
        storedTimeBlock.colorName = "alizarin"
        storedTimeBlock.startTime = 8
        storedTimeBlock.endTime = 9

        return ZStack {
            BackgroundView()

            TimelineItem(storedTimeBlock: storedTimeBlock)
        }
    }
}
