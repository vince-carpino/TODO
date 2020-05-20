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
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Item.entity(), sortDescriptors: []) var items: FetchedResults<Item>

    var body: some View {
        ZStack {
            NavigationView {
                List(items, id: \.id) { item in
                    NavigationLink(destination: ItemDetailView(item: item)) {
                        Text(item.name ?? "NAME NOT FOUND")
                    }
                }
                .navigationBarTitle(Text("Items"))
            }

            VStack {
                Spacer()

                HStack {
                    Spacer()

                    AddItemButton()
                    .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let item1 = Item(context: moc)
        item1.id = UUID()
        item1.name = "Wash car"

        let item2 = Item(context: moc)
        item2.id = UUID()
        item2.name = "Throw in laundry"

        return ItemListView().environment(\.managedObjectContext, moc)
    }
}
