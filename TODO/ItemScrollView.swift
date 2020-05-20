//
//  ItemScrollView.swift
//  TODO:
//
//  Created by Vince Carpino on 5/18/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import CoreData
import SwiftUI

struct ItemScrollView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Item.entity(), sortDescriptors: [ NSSortDescriptor(key: "creationTime", ascending: true) ]) var items: FetchedResults<Item>

    var body: some View {
        ZStack {
            Color.midnightBlue
                .edgesIgnoringSafeArea(.all)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 40) {
                    ForEach(items.filter { !$0.hasBeenDeleted }, id: \.id) { item in
                        ItemPreview(item: item)
                    }
                }
            }
            .padding()

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

struct ItemScrollView_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let item1 = Item(context: moc)
        item1.id = UUID()
        item1.name = "Wash car"
        item1.creationTime = Date()

        let item2 = Item(context: moc)
        item2.id = UUID()
        item2.name = "Should not be seen"
        item2.creationTime = Date()
        item2.hasBeenDeleted = true

        let item3 = Item(context: moc)
        item3.id = UUID()
        item3.name = "Throw in laundry"
        item3.creationTime = Date()

        let item4 = Item(context: moc)
        item4.id = UUID()
        item4.name = String(repeating: "Just a really long name ", count: 5)
        item4.creationTime = Date()

        return ItemScrollView().environment(\.managedObjectContext, moc)
    }
}
