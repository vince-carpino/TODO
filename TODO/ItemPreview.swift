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

    @State private var isPresentingDetail = false

    var body: some View {
        Button(action: {
            print("tapped on \(self.item.name ?? "Unknown name")")

            self.isPresentingDetail = true
        }) {
            VStack(alignment: .leading) {
                Text(item.name ?? "Unknown name")
                    .font(.title)
                    .bold()
                    .lineLimit(3)
                    .truncationMode(.tail)

                Text("Name")
                    .font(.headline)
            }
            .padding(30)
            .foregroundColor(.white)
            .background(Color(red: 22/255, green: 160/255, blue: 132/255))
            .cornerRadius(10)
        }
        .sheet(isPresented: $isPresentingDetail) {
            ItemDetailView(item: self.item)
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
