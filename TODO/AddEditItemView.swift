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

    let item: Item?

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }

    var body: some View {
        ZStack {
            Color.midnightBlue
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text(self.isNewItem() ? "Add Item" : "Edit Item")
                    .font(.largeTitle)
                    .foregroundColor(.clouds)
                    .bold()
                    .padding(.bottom, 15)

                Spacer()

                Form {
                    Section {
                        if self.isNewItem() {
                            TextField("Enter a name...", text: $itemName)
                        } else {
                            TextField("Enter a name...", text: $newName)
                                .onAppear {
                                    self.newName = self.item?.name ?? ""
                                }
                        }
                    }

                    Section {
                        Toggle(isOn: $hasDueDate) {
                            HStack {
                                Text("Due date")
                                Spacer()
                            }
                        }
                        .onAppear {
                            self.hasDueDate = self.item?.hasDueDate ?? false
                        }

                        if hasDueDate {
                            DatePicker("Select a date", selection: $dueDate, in: Date()..., displayedComponents: .date)
                                .onAppear {
                                    self.dueDate = self.item?.dueDate ?? Date()
                                }
                        }
                    }
                }

//                VStack {
//                    VStack(alignment: .leading) {
//                        Text("Name")
//                            .font(.headline)
//                            .foregroundColor(.clouds)
//                            .bold()
//                            .padding(.bottom, -10)
//
//                        if self.isNewItem() {
//                            TextField("Enter a name...", text: $itemName)
//                                .textFieldStyle(RoundedBorderTextFieldStyle())
//                                .keyboardType(.default)
//                        } else {
//                            TextField("Enter a name...", text: $newName)
//                                .textFieldStyle(RoundedBorderTextFieldStyle())
//                                .keyboardType(.default)
//                                .onAppear(perform: {
//                                    self.newName = self.item?.name ?? ""
//                            })
//                        }
//                    }
//
//                    VStack {
//                        HStack {
//                            Text("Due date")
//                                .foregroundColor(.clouds)
//                                .font(.headline)
//
//                            Spacer()
//
//                            Toggle(isOn: self.$hasDueDate) {
//                                Text("")
//                            }
//                        }
//
//                        if hasDueDate {
//                            DatePicker("Select a date", selection: $dueDate, in: Date()..., displayedComponents: .date)
//                                .foregroundColor(.clouds)
//                                .labelsHidden()
//                        }
//                    }
//                }

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
                            Image(systemName: isNewItem() ? "plus" : "checkmark.square.fill")

                            Text(self.isNewItem() ? "Add Item" : "Save")
                                .fontWeight(.semibold)
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
                        .font(.footnote)
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

    fileprivate func addNewItem() {
        let item = Item(context: self.moc)
        item.id = UUID()
        item.name = self.itemName
        item.creationTime = Date()
        item.hasBeenDeleted = false
        item.hasDueDate = self.hasDueDate

        if item.hasDueDate {
            item.dueDate = self.dueDate
        }

        do {
            try self.moc.save()
            print("saved item: \(item.name ?? "NIL NAME") with hasDueDate: \(self.hasDueDate) with dueDate \(self.dueDate)")
        } catch {
            print("Error while saving item:\n***\n\(error)\n***")
        }
    }

    fileprivate func saveItem() {
        self.moc.performAndWait {
            item?.name = self.newName
            item?.hasDueDate = self.hasDueDate

            if self.hasDueDate {
                item?.dueDate = self.dueDate
            }

            do {
                try self.moc.save()
                print("saved item: \(self.item?.name ?? "NIL NAME") with hasDueDate: \(self.hasDueDate) with dueDate \(self.dueDate)")
            } catch {
                print("Error while saving item:\n***\n\(error)\n***")
            }
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

        return Group {
            AddEditItemView(item: nil)
            AddEditItemView(item: item)
        }
    }
}
