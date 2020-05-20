//
//  AddItemView.swift
//
//  Created by Vince Carpino on 5/11/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    @State private var itemName = ""

    var body: some View {
        ZStack {
            Color.midnightBlue
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Add an item")
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

                    TextField("Enter a name...", text: $itemName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.default)
                }

                Spacer()

                VStack {
                    Button(action: {
                        self.addNewItem()
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "plus")

                            Text("Add Item")
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
        return self.itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var buttonColor: Color {
        return nameFieldIsEmpty() ? .concrete : .peterRiver
    }

    fileprivate func addNewItem() {
        let item = Item(context: self.moc)
        item.id = UUID()
        item.name = self.itemName

        do {
            try self.moc.save()
        } catch {
            print("THERE WAS AN ERROR SAVING ITEM")
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
