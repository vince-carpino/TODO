//
//  ItemDetailView.swift
//  TODO
//
//  Created by Vince Carpino on 5/11/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import CoreData
import SwiftUI

struct ItemDetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    @FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Item.isCurrentItem, ascending: true)], predicate: NSPredicate(format: "isCurrentItem == true")) var currentItem: FetchedResults<Item>

    @State private var isPresentingDeleteConfirmation = false
    @State private var isPresentingEditSheet = false

    @State private var isCompleted = false
    @State private var isCurrentItem = false

    let item: Item

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter
    }

    private let priorityMap = [0: "Low", 50: "Medium", 100: "High"]

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(alignment: .leading) {
                Spacer()

                VStack(alignment: .leading) {
                    ItemPropertyDetail(propertyValue: item.name ?? "", propertyName: "Name")
                        .lineLimit(3)

                    ItemPropertyDetail(propertyValue: self.priorityMap[Int(item.priorityValue)] ?? "Low", propertyName: "Priority")

                    ItemPropertyDetail(propertyValue: dateFormatter.string(from: item.creationTime ?? Date()), propertyName: "Creation time")

                    ItemPropertyDetail(propertyValue: item.hasDueDate ? dateFormatter.string(from: item.dueDate ?? Date()) : "No due date", propertyName: "Due date")
                }

                Spacer()

                VStack {
                    Button(action: {
                        self.item.isCurrentItem.toggle()
                        self.isCurrentItem = self.item.isCurrentItem

                        if self.isCurrentItem {
                            self.markPreviousCurrentItemAsNotCurrent()
                            self.item.isCompleted = false
                            self.isCompleted = self.item.isCompleted
                        }

                        print("MARKED AS \(self.isCurrentItem ? "" : "NOT ")CURRENT")

                        self.saveContext()
                    }) {
                        HStack {
                            Image(systemName: self.$isCurrentItem.wrappedValue ? "bolt.slash.fill" : "bolt.fill")

                            Text("\(self.$isCurrentItem.wrappedValue ? "Don't " : "")Set as Current")
                        }
                        .formatted(fontSize: 18)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(self.$isCurrentItem.wrappedValue ? Color.completedItemColor : Color.currentItemColor)
                        .cornerRadius(40)
                    }

                    Button(action: {
                        self.item.isCompleted.toggle()
                        self.isCompleted = self.item.isCompleted

                        if self.isCompleted {
                            self.item.isCurrentItem = false
                            self.isCurrentItem = self.item.isCurrentItem
                            self.presentationMode.wrappedValue.dismiss()
                        }

                        self.saveContext()
                    }) {
                        HStack {
                            Image(systemName: self.$isCompleted.wrappedValue ? "nosign" : "checkmark.square.fill")

                            Text("Mark as \(self.$isCompleted.wrappedValue ? "Incomplete" : "Done")")
                        }
                        .formatted(fontSize: 18)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(self.$isCompleted.wrappedValue ? Color.completedItemColor : Color.nephritis)
                        .cornerRadius(40)
                    }

                    HStack {
                        Button(action: {
                            self.isPresentingDeleteConfirmation = true
                        }) {
                            HStack {
                                Image(systemName: "trash")

                                Text("Delete Item")
                            }
                            .formatted(fontSize: 18, foregroundColor: .alizarin)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .overlay(RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.alizarin, lineWidth: 3)
                            )
                        }
                        .alert(isPresented: self.$isPresentingDeleteConfirmation) {
                            let title: Text = Text("Are you sure?")
                            let message: Text = Text("This cannot be undone")
                            let okayButton = Alert.Button.destructive(Text("Yes"), action: {
                                self.item.hasBeenDeleted = true

                                self.saveContext()
                            })
                            let cancelButton = Alert.Button.cancel(Text("Wait nvm")) {}

                            return Alert(title: title, message: message, primaryButton: okayButton, secondaryButton: cancelButton)
                        }

                        Button(action: {
                            self.isPresentingEditSheet = true
                        }) {
                            HStack {
                                Image(systemName: "slider.horizontal.3")

                                Text("Edit Item")
                            }
                            .formatted(fontSize: 18, foregroundColor: .peterRiver)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .overlay(RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.peterRiver, lineWidth: 3)
                            )
                        }
                        .sheet(isPresented: $isPresentingEditSheet) {
                            AddEditItemView(item: self.item).environment(\.managedObjectContext, self.moc)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            self.isCompleted = self.item.isCompleted
            self.isCurrentItem = self.item.isCurrentItem
        }
    }

    private func saveContext() {
        do {
            try moc.save()
        } catch {
            print("Error while saving item:\n***\n\(error)\n***")
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
}

struct ItemDetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let item = Item(context: moc)
        item.id = UUID()
        item.name = "Test item"
        item.creationTime = Date()
        item.hasDueDate = true
        item.dueDate = Date()
        item.hasBeenDeleted = false
        item.isCurrentItem = false
        item.priorityValue = 50

        let itemWithLongName = Item(context: moc)
        itemWithLongName.id = UUID()
        itemWithLongName.name = String(repeating: "Here's a long name ", count: 5)
        itemWithLongName.creationTime = Date()
        itemWithLongName.hasDueDate = true
        itemWithLongName.dueDate = Date()
        itemWithLongName.hasBeenDeleted = false
        itemWithLongName.isCurrentItem = false

        return Group {
            ItemDetailView(item: item)

            ItemDetailView(item: itemWithLongName)
        }
    }
}

struct ItemPropertyDetail: View {
    let propertyValue: String
    let propertyName: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(propertyValue)
                .formatted(fontSize: 28)

            Text(propertyName)
                .formatted(fontSize: 14)
        }
        .padding()
    }
}
