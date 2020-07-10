//
//  ItemPreview.swift
//  TODO
//
//  Created by Vince Carpino on 5/18/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import CoreData
import SwiftUI

struct ItemPreview: View {
    @Environment(\.managedObjectContext) var moc

    @State private var isPresentingDetail = false

    let item: Item

    var body: some View {
        Button(action: {
            self.isPresentingDetail = true
        }) {
            Text(item.name ?? "Unknown name")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .bold()
                .lineLimit(3)
                .truncationMode(.tail)
                .padding(30)
                .foregroundColor(.clouds)
                .background(getBackgroundColor(item: item))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.clouds, lineWidth: 5)
                )
        }
        .sheet(isPresented: $isPresentingDetail) {
            ItemDetailView(item: self.item).environment(\.managedObjectContext, self.moc)
        }
    }
}

private func getBackgroundColor(item: Item) -> Color {
    return item.isCompleted ? .completedItemColor : item.isCurrentItem ? .currentItemColor : .incompleteItemColor
}

struct ItemPreview_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let item = Item(context: moc)
        item.id = UUID()
        item.name = "Some name"
        item.isCompleted = false
        item.isCurrentItem = true

        return ZStack {
            RainbowViewVertical()

            ItemPreview(item: item)
        }
    }
}
