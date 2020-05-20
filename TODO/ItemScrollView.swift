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
    @FetchRequest(entity: Item.entity(), sortDescriptors: []) var items: FetchedResults<Item>

    var body: some View {
        ZStack {
            Color.midnightBlue
                .edgesIgnoringSafeArea(.all)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 40) {
                    ForEach(items, id: \.id) { item in
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

        let item2 = Item(context: moc)
        item2.id = UUID()
        item2.name = "Throw in laundry"

        let item3 = Item(context: moc)
        item3.id = UUID()
        item3.name = String(repeating: "Just a really long name ", count: 5)

        return ItemScrollView().environment(\.managedObjectContext, moc)
    }
}
