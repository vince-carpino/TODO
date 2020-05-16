//
//  AddItemButton.swift
//  TODO:
//
//  Created by Vince Carpino on 5/12/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import SwiftUI

struct AddItemButton: View {
    @Environment(\.managedObjectContext) var moc
    @Binding var showAddView: Bool

//    @Binding var itemsList: [Item]

    var body: some View {
        Button(action: {
//            print("\n\nAdd item...")
            self.showAddView = true
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .imageScale(.large)
                .foregroundColor(.blue)
        }
        .sheet(isPresented: $showAddView) {
            AddItemView().environment(\.managedObjectContext, self.moc)
        }
    }
}

struct AddItemButton_Previews: PreviewProvider {
    static var previews: some View {
        AddItemButton(showAddView: Binding.constant(false))
    }
}
