//
//  ItemPreview.swift
//  TODO
//
//  Created by Vince Carpino on 5/18/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import CoreData
import SwiftUI

struct ItemPreview: View {
    @Environment(\.managedObjectContext) var moc

    @State private var isPresentingDetail = false

    let item: Item

    var body: some View {
        Button(action: {
            print("tapped on \(self.item.name ?? "Unknown name")")

            self.isPresentingDetail = true
        }) {
            Text(item.name ?? "Unknown name")
                .font(.title)
                .bold()
                .lineLimit(3)
                .truncationMode(.tail)
                .padding(30)
                .foregroundColor(.clouds)
                .background(Color.greenSea)
                .cornerRadius(10)
        }
        .sheet(isPresented: $isPresentingDetail) {
            ItemDetailView(item: self.item).environment(\.managedObjectContext, self.moc)
        }
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
