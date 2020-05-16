//
//  ContentView.swift
//  TODO:
//
//  Created by Vince Carpino on 4/20/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import CoreData
import SwiftUI

struct ItemListView: View {
//    @State private var items = [Item]()
//    @State private var items: [Item]
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Item.entity(), sortDescriptors: []) var items: FetchedResults<Item>

    @State private var showingAddItemView = false

    var body: some View {
        VStack {
            List {
                ForEach(items, id: \.id) { item in
                    Text(item.name ?? "NAME NOT FOUND")
                }
            }

            Button("Add") {
                self.showingAddItemView.toggle()
//                let itemNames = [
//                    "One",
//                    "Two",
//                    "Three",
//                    "Four",
//                    "Five"
//                ]
//
//                let item = Item(context: self.moc)
//                item.id = UUID()
//                item.name = "\(itemNames.randomElement()!) \(itemNames.randomElement()!)"
//
//                do {
//                    try self.moc.save()
//                } catch {
//                    print("THERE WAS AN ERROR SAVING ITEM")
//                }
            }
            .sheet(isPresented: $showingAddItemView) {
                AddItemView().environment(\.managedObjectContext, self.moc)
            }
        }

//        ZStack {
//            NavigationView {
//                List(items, id: \.id) { item in
//                    NavigationLink(destination: ItemDetailView(item: item)) {
//                        Text(item.name ?? "NAME NOT FOUND")
//                    }
//                }
//                .navigationBarTitle(Text("Items"))
//
//                VStack {
//                    Spacer()
//
//                    HStack {
//                    Button(action: {
//        //                        print("\n\nItems current: \(self.items)")
//        //                        print("\nDefaults current: \(self.getDecodedItemsList())")
//                    }) {
//                        Text("Refresh")
//                    }
//                    .padding()
//
//                        Spacer()
//
//                        AddItemButton(showAddView: $showingAddItemView)
//                            .padding()
//                    }
//                }
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        ItemListView(itemsList: Binding.constant([Item()]))
        ItemListView()
    }
}
