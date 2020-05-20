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

    let item: Item

    var body: some View {
        ZStack {
            Color.midnightBlue
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                VStack(alignment: .leading) {
                    Text(item.name ?? "")
                        .font(.title)
                        .foregroundColor(.clouds)
                        .bold()

                    Text("Name")
                        .font(.subheadline)
                        .foregroundColor(.clouds)
                }
                .padding()

                Spacer()

                HStack {
                    Button(action: {
                        print("Delete Item...")

                        self.isPresentingDeleteConfirmation = true
                        //
                        //                    self.moc.delete(self.item)
                        //
                        //                    do {
                        //                        try self.moc.save()
                        //                    } catch {
                        //                        print("THERE WAS AN ERROR SAVING")
                        //                    }

                    }) {
                        HStack {
                            Image(systemName: "xmark")
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
                        let okayButton = Alert.Button.default(Text("Yes"), action: {
                            print("DELETE ITEM NOW")
                            self.moc.delete(self.item)

                            do {
                                try self.moc.save()
                            } catch {
                                print("THERE WAS AN ERROR SAVING")
                            }
                        })
                        let cancelButton = Alert.Button.cancel(Text("Wait nvm")) {
                            print("DON'T DO IT")
                        }

                        return Alert(title: title, message: message, primaryButton: okayButton, secondaryButton: cancelButton)
                    }

                    Button(action: {
                        print("Edit Item...")
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
        return NavigationView {
            ItemDetailView(item: item)
        }
    }
}
