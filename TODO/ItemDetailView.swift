//
//  ItemDetailView.swift
//  TODO:
//
//  Created by Vince Carpino on 5/11/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import SwiftUI

struct ItemDetailView: View {
    var item: Item

    var body: some View {
        VStack {
            VStack {
                Text("Name")
                    .bold()

                Text(item.name)
            }

            VStack {
                Text("Id")
                    .bold()

                Text("\(item.id)")
            }
        }
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView(item: Item(name: "some item", id: 3))
    }
}
