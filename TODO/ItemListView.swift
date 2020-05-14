//
//  ContentView.swift
//  TODO:
//
//  Created by Vince Carpino on 4/20/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import SwiftUI

struct ItemListView: View {
    @State var items = UserDefaults.standard.object(forKey: "items") as? [Item] ?? [Item]()

    var body: some View {
        ZStack {
            NavigationView {
                List(items) { item in
                    NavigationLink(destination: ItemDetailView(item: item)) {
                        Text(item.name)
                    }
                }
                .navigationBarTitle(Text("Items"))
            }

            VStack {
                Spacer()

                HStack {
                    Spacer()

                    AddItemButton(showAddView: false)
                        .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView()
    }
}
