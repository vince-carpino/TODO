//
//  AddItemButton.swift
//  TODO:
//
//  Created by Vince Carpino on 5/12/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import SwiftUI

struct AddItemButton: View {
    @State var showAddView: Bool

    var body: some View {
        Button(action: {
            print("Add item...")
            self.showAddView = true
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .imageScale(.large)
                .foregroundColor(.blue)
        }
        .sheet(isPresented: $showAddView) {
            AddItemView(itemName: "")
        }
    }
}

struct AddItemButton_Previews: PreviewProvider {
    static var previews: some View {
        AddItemButton(showAddView: false)
    }
}
