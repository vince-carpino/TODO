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

    var body: some View {
        ZStack {
            Color.midnightBlue
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
                Spacer()

                VStack(alignment: .leading) {
                    ItemPropertyDetail(propertyValue: item.name ?? "", propertyName: "Name")

                    ItemPropertyDetail(propertyValue: dateFormatter.string(from: item.creationTime ?? Date()), propertyName: "Creation time")

                    ItemPropertyDetail(propertyValue: item.hasDueDate ? dateFormatter.string(from: item.dueDate ?? Date()) : "No due date", propertyName: "Due date")
                }

                Spacer()

                VStack {
                    Button(action: {
                        self.item.isCurrentItem.toggle()
                        self.isCurrentItem = self.item.isCurrentItem

                        if self.isCurrentItem {
                            self.item.isCompleted = false
                            self.isCompleted = self.item.isCompleted
                        }

                        print("MARKED AS \(self.isCurrentItem ? "" : "NOT ")CURRENT")

                        do {
                            try self.moc.save()
                        } catch {
                            print("ERROR WHILE SAVING")
                        }
                    }) {
                        HStack {
                            Image(systemName: self.$isCurrentItem.wrappedValue ? "bolt.slash.fill" : "bolt.fill")
                                .imageScale(.medium)

                            Text("\(self.$isCurrentItem.wrappedValue ? "Don't " : "")Set as Current")
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(.clouds)
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

                        do {
                            try self.moc.save()
                        } catch {
                            print("ERROR WHILE SAVING")
                        }
                    }) {
                        HStack {
                            Image(systemName: self.$isCompleted.wrappedValue ? "nosign" : "checkmark")
                                .imageScale(.medium)

                            Text("Mark as \(self.$isCompleted.wrappedValue ? "Incomplete" : "Done")")
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(.clouds)
                        .background(self.$isCompleted.wrappedValue ? Color.completedItemColor : Color.nephritis)
                        .cornerRadius(40)
                    }

                    HStack {
                        Button(action: {
                            self.isPresentingDeleteConfirmation = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                    .imageScale(.medium)

                                Text("Delete Item")
                                    .fontWeight(.semibold)
                            }
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .foregroundColor(.alizarin)
                            .overlay(RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.alizarin, lineWidth: 3)
                            )
                        }
                        .alert(isPresented: self.$isPresentingDeleteConfirmation) {
                            let title: Text = Text("Are you sure?")
                            let message: Text = Text("This cannot be undone")
                            let okayButton = Alert.Button.destructive(Text("Yes"), action: {
                                self.item.hasBeenDeleted = true

                                do {
                                    try self.moc.save()
                                } catch {
                                    print("ERROR WHILE SAVING")
                                }
                            })
                            let cancelButton = Alert.Button.cancel(Text("Wait nvm")) {}

                            return Alert(title: title, message: message, primaryButton: okayButton, secondaryButton: cancelButton)
                        }

                        Button(action: {
                            self.isPresentingEditSheet = true
                        }) {
                            HStack {
                                Image(systemName: "slider.horizontal.3")
                                    .imageScale(.medium)

                                Text("Edit Item")
                                    .fontWeight(.semibold)
                            }
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .foregroundColor(.peterRiver)
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

        return ItemDetailView(item: item)
    }
}

struct ItemPropertyDetail: View {
    let propertyValue: String
    let propertyName: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(propertyValue)
                .font(.title)
                .bold()

            Text(propertyName)
                .font(.subheadline)
        }
        .foregroundColor(.clouds)
        .padding()
    }
}
