//
//  ItemDetailView.swift
//  TODO:
//
//  Created by Vince Carpino on 5/11/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import CoreData
import SwiftUI

struct ItemDetailView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var isPresentingDeleteConfirmation = false
    @State private var isPresentingEditSheet = false

    let item: Item

    var body: some View {
        ZStack {
            Color.midnightBlue
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(item.name ?? "")
                            .font(.title)
                            .foregroundColor(.clouds)
                            .bold()
                            .lineLimit(5)
                            .truncationMode(.tail)

                        Text("Name")
                            .font(.subheadline)
                            .foregroundColor(.clouds)
                    }
                    .padding()

                    VStack(alignment: .leading) {
                        Text("\(item.creationTime ?? Date())")
                            .font(.title)
                            .foregroundColor(.clouds)
                            .bold()

                        Text("Creation Time")
                            .font(.subheadline)
                            .foregroundColor(.clouds)
                    }
                    .padding()
                }

                Spacer()

                HStack {
                    Button(action: {
                        print("Delete Item...")

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
                        .foregroundColor(.clouds)
                        .background(Color.alizarin)
                        .cornerRadius(40)
                    }
                    .alert(isPresented: self.$isPresentingDeleteConfirmation) {
                        let title: Text = Text("Are you sure?")
                        let message: Text = Text("This cannot be undone")
                        let okayButton = Alert.Button.destructive(Text("Yes"), action: {
                            print("MARKING AS DELETED")
                            self.item.hasBeenDeleted = true

                            do {
                                try self.moc.save()
                            } catch {
                                print("ERROR WHILE SAVING")
                            }
                        })
                        let cancelButton = Alert.Button.cancel(Text("Wait nvm")) {
                            print("DON'T DO IT")
                        }

                        return Alert(title: title, message: message, primaryButton: okayButton, secondaryButton: cancelButton)
                    }

                    Button(action: {
                        print("Edit Item...")
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
                        .foregroundColor(.clouds)
                        .background(Color.peterRiver)
                        .cornerRadius(40)
                    }
                    .sheet(isPresented: $isPresentingEditSheet) {
                        EditItemView(item: self.item).environment(\.managedObjectContext, self.moc)
                    }
                }
                .padding()
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
        item.hasBeenDeleted = false

        return ItemDetailView(item: item)
    }
}
