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

    @State private var isPresentingDetail = false
    @State private var isPresentingMenuOptions = false

    let item: Item

    var body: some View {
        VStack(spacing: 40) {
            if isPresentingMenuOptions {
                LongPressMenuButton(isPresented: self.$isPresentingMenuOptions, iconName: "bolt.fill", label: "mark current", accentColor: .currentItemColor)
            }

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
                    .onTapGesture(count: 2) {
                        print("DOUBLE TAPPED")
                    }
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

            if isPresentingMenuOptions {
                LongPressMenuButton(isPresented: self.$isPresentingMenuOptions, iconName: "checkmark.square.fill", label: "mark complete", accentColor: .completedItemColor)
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

            ItemPreview(item: item)
        }
    }
}

struct LongPressMenuButton: View {
    @Binding var isPresented: Bool

    var iconName: String
    var label: String
    var accentColor: Color

    var body: some View {
        Button(action: {
            withAnimation {
                self.isPresented = false
            }
        }) {
            VStack {
                Image(systemName: iconName)
                    .frame(width: 60, height: 60)
                    .imageScale(.large)
                    .foregroundColor(.clouds)
                    .background(accentColor)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.clouds, lineWidth: 3)
                    )
                Text(label)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .padding(5)
                    .background(Color.clouds)
                    .cornerRadius(5)
                    .foregroundColor(accentColor)
            }
        }
        .transition(.scale)
    }
}
