//
//  AddEditItemView.swift
//  TODO
//
//  Created by Vince Carpino on 5/20/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import CoreData
import SwiftUI

struct AddEditItemView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    @State private var itemName = ""
    @State private var newName = ""

    @State private var hasDueDate = false
    @State private var dueDate = Date()
    @State private var hasDueTime = false

    @State private var priorityIndex = 0
    @State private var timelineIndex = 0

    private let priorities = ["LOW", "MEDIUM", "HIGH"]
    private let timelines = ["LATER", "TODAY", "NEXT"]
    private let prioritiesValues = [0, 50, 100]
    private let prioritiesMap = ["LOW": 0, "MEDIUM": 50, "HIGH": 100]

    let item: Item?

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }

    var body: some View {
        ZStack {
            BackgroundView()

            VStack {
                Text(self.isNewItem() ? "Add Item" : "Edit Item")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                    .foregroundColor(.clouds)
                    .bold()
                    .padding(.bottom, 15)

                Spacer()

                Form {
                    Section(header: Text("NAME")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                    ) {
                        TextField("Enter a name...", text: self.isNewItem() ? $itemName : $newName)
                            .onAppear {
                                self.newName = self.item?.name ?? ""
                            }
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                    }
                }

                Spacer()

                VStack {
                    Button(action: {
                        if self.isNewItem() {
                            self.addNewItem()
                        } else {
                            self.saveItem()
                        }

                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: isNewItem() ? "plus" : "arrow.down.square.fill")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))

                            Text(self.isNewItem() ? "Add Item" : "Save")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                        }
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(.clouds)
                        .background(buttonColor)
                        .cornerRadius(40)
                    }
                    .disabled(self.nameFieldIsEmpty())

                    Text("swipe down to cancel")
                        .foregroundColor(.silver)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
            }
            .padding()
        }
    }

    fileprivate func isNewItem() -> Bool {
        return self.item == nil
    }

    fileprivate func nameFieldIsEmpty() -> Bool {
        let textFieldToWatch = self.isNewItem() ? self.itemName : self.newName
        return textFieldToWatch.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var buttonColor: Color {
        return self.nameFieldIsEmpty() ? .concrete : .peterRiver
    }

    private func getPriorityValue() -> Int16 {
        let selectedPriority = self.priorities[self.priorityIndex]
        return Int16(self.prioritiesMap[selectedPriority] ?? -1)
    }

    private func getPriorityIndexFromValue(_ value: Int16) -> Int {
        return self.prioritiesValues.firstIndex(of: Int(value)) ?? 0
    }

    fileprivate func addNewItem() {
        let item = Item(context: self.moc)
        item.id = UUID()
        item.name = self.itemName
        item.creationTime = Date()
        item.hasBeenDeleted = false
        item.isCompleted = false
        item.hasDueDate = self.hasDueDate
        item.hasDueTime = self.hasDueTime
        item.priorityValue = self.getPriorityValue()

        if item.hasDueDate, !item.hasDueTime {
            item.dueDate = Calendar.current.date(bySetting: .hour, value: 1, of: self.dueDate)
            item.dueDate = Calendar.current.date(bySetting: .minute, value: 0, of: self.dueDate)
            item.dueDate = Calendar.current.date(bySetting: .second, value: 0, of: self.dueDate)
        } else if self.hasDueDate, self.hasDueTime {
            item.dueDate = self.dueDate
        }

        self.saveContext()
    }

    fileprivate func saveContext() {
        do {
            try self.moc.save()
        } catch {
            print("Error while saving item:\n***\n\(error)\n***")
        }
    }

    fileprivate func saveItem() {
        self.moc.performAndWait {
            item?.name = self.newName
            item?.hasDueDate = self.hasDueDate
            item?.priorityValue = self.getPriorityValue()

            if self.hasDueDate {
                item?.dueDate = self.dueDate
            }

            saveContext()
        }
    }
}

struct AddEditItemView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let item = Item(context: moc)
        item.id = UUID()
        item.name = "Test item"
        item.creationTime = Date()
        item.hasBeenDeleted = false
        item.hasDueDate = true
        item.hasDueTime = true

        return Group {
            AddEditItemView(item: nil)
            AddEditItemView(item: item)
        }
    }
}
