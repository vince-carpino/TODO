//
//  ItemScrollView.swift
//  TODO
//
//  Created by Vince Carpino on 5/18/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import CoreData
import SwiftUI

struct ItemScrollView: View {
    @Environment(\.managedObjectContext) var moc

    @State private var isPresentingQuickAddItemView = false
    @State private var viewModeFilter = 0

    private var viewModeFilterOptions = ["NEXT", "TODAY", "ALL"]

    @FetchRequest(entity: Item.entity(), sortDescriptors: [
        NSSortDescriptor(key: "priorityValue", ascending: false),
        NSSortDescriptor(key: "dueDate", ascending: true),
        NSSortDescriptor(key: "creationTime", ascending: true)
    ]) var items: FetchedResults<Item>

    var body: some View {
        ZStack {
            Color.midnightBlue
                .edgesIgnoringSafeArea(.all)

            VStack {
                Picker(selection: self.$viewModeFilter, label: Text("")) {
                    ForEach(0..<viewModeFilterOptions.count) { index in
                        Text(self.viewModeFilterOptions[index])
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 40) {
                        Spacer(minLength: 0)

                        ForEach(items.filter { !$0.hasBeenDeleted }, id: \.id) { item in
                            ItemPreview(item: item)
                        }

                        Spacer(minLength: 50)
                    }
                }
                .padding()

                Spacer(minLength: 45)
            }

            VStack {
                Spacer()

                ZStack {
                    AddItemButton(isPresentingQuickAddItemView: self.$isPresentingQuickAddItemView)
                        .padding()
                }
            }

            if isPresentingQuickAddItemView {
                QuickAddItemView(isPresented: self.$isPresentingQuickAddItemView)
                    .transition(.opacity)
            }
        }
    }
}

struct ItemScrollView_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let oneDayInSeconds = Double(24 * 60 * 60)

        let item1 = Item(context: moc)
        item1.id = UUID()
        item1.name = "Wash car"
        item1.creationTime = Date()
        item1.dueDate = Date()

        let item2 = Item(context: moc)
        item2.id = UUID()
        item2.name = "Should not be seen"
        item2.creationTime = Date()
        item2.hasBeenDeleted = true
        item2.dueDate = Date().advanced(by: 1 * oneDayInSeconds)

        let item3 = Item(context: moc)
        item3.id = UUID()
        item3.name = "Throw in laundry"
        item3.creationTime = Date()
        item3.dueDate = Date().advanced(by: -2 * oneDayInSeconds)

        let item4 = Item(context: moc)
        item4.id = UUID()
        item4.name = String(repeating: "Just a really long name ", count: 5)
        item4.creationTime = Date()
        item4.dueDate = Date().advanced(by: 3 * oneDayInSeconds)

        return ItemScrollView().environment(\.managedObjectContext, moc)
    }
}
