//
//  EditItemView.swift
//  TODO
//
//  Created by Vince Carpino on 5/20/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import CoreData
import SwiftUI

struct EditItemView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    @State private var newName = ""

    let item: Item

    var body: some View {
        ZStack {
            Color.midnightBlue
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Edit item")
                    .font(.largeTitle)
                    .foregroundColor(.clouds)
                    .bold()

                Spacer()

                VStack(alignment: .leading) {
                    Text("Name")
                        .font(.title)
                        .foregroundColor(.clouds)
                        .bold()
                        .padding(.bottom, -10)

                    TextField("Enter a name...", text: $newName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.default)
                        .onAppear(perform: {
                            self.newName = self.item.name ?? ""
                        })
                }

                Spacer()

                VStack {
                    Button(action: {
                        self.saveItem()
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "checkmark.square.fill")

                            Text("Save")
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

    fileprivate func nameFieldIsEmpty() -> Bool {
        return self.newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var buttonColor: Color {
        return self.nameFieldIsEmpty() ? .concrete : .peterRiver
    }

    fileprivate func saveItem() {
        self.moc.performAndWait {
            item.name = self.newName
            
            do {
                try self.moc.save()
                print("saved item: \(self.item.name ?? "NIL NAME")")
            } catch {
                print("Error while saving item:\n***\n\(error)\n***")
            }
        }
    }
}

struct EditItemView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let item = Item(context: moc)
        item.id = UUID()
        item.name = "Test item"
        item.creationTime = Date()
        item.hasBeenDeleted = false

        return EditItemView(item: item)
    }
}
