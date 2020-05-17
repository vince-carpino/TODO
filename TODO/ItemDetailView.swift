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
    let item: Item

    var body: some View {
        VStack {
            Spacer()

            VStack(alignment: .leading) {
                Text(item.name ?? "")
                    .font(.title)
                    .bold()

                Text("Name")
                    .font(.subheadline)
            }

            Spacer()

            HStack {
                Button(action: {
                    print("Delete Item...")
                }) {
                    HStack {
                        Image(systemName: "xmark")
                            .imageScale(.medium)

                        Text("Delete Item")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(40)
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
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(40)
                }
            }
            .padding()
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
