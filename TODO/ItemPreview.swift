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

    @FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Item.isCurrentItem, ascending: true)], predicate: NSPredicate(format: "isCurrentItem == true")) var currentItem: FetchedResults<Item>

    @Binding var isPresentingMenuOptions: Bool
    @State private var isPresentingDetail = false

    let item: Item

    var body: some View {
        ZStack {
            Button(action: {}) {
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
                            .strokeBorder(Color.clouds, lineWidth: 5)
                    )
                    .onTapGesture {
                        self.isPresentingDetail = true
                    }
                    .onLongPressGesture {
                        withAnimation {
                            self.isPresentingMenuOptions = true
                        }
//                        self.markPreviousCurrentItemAsNotCurrent()
//                        self.item.isCompleted = false
//                        self.item.isCurrentItem = true
//                        self.saveContext()
                    }
            }
            .sheet(isPresented: $isPresentingDetail) {
                ItemDetailView(item: self.item).environment(\.managedObjectContext, self.moc)
            }
        }
    }

    private func markPreviousCurrentItemAsNotCurrent() {
        if currentItem.first == nil {
            print("NO ITEM MARKED AS CURRENT")
            return
        }

        if let previousCurrentItem = currentItem.first {
            moc.performAndWait {
                previousCurrentItem.isCurrentItem = false
            }
        }
    }

    private func saveContext() {
        do {
            try moc.save()
        } catch {
            print("Error while saving item:\n***\n\(error)\n***")
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

            ItemPreview(isPresentingMenuOptions: Binding.constant(false), item: item)
        }
    }
}
