//
//  ItemPreview.swift
//  TODO:
//
//  Created by Vince Carpino on 5/18/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import CoreData
import SwiftUI

struct ItemPreview: View {
    let item: Item

    var body: some View {
        VStack(alignment: .leading) {
            Text(item.name ?? "Unknown name")
                .font(.title)
                .bold()

            Text("Name")
                .font(.headline)
        }
        .padding(30)
        .foregroundColor(.white)
        .background(Color.blue)
        .cornerRadius(10)
    }
}

struct ItemPreview_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let item = Item(context: moc)
        item.id = UUID()
        item.name = "Some name"

        return ItemPreview(item: item)
    }
}
