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

    @State private var isPresentingAddItemView = false

    var body: some View {
        Button(action: {
            self.isPresentingAddItemView = true
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .imageScale(.large)
                .foregroundColor(.blue)
                .background(Color.white)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 3)
                )
        }
        .sheet(isPresented: $isPresentingAddItemView) {
            AddItemView().environment(\.managedObjectContext, self.moc)
        }
    }
}

struct AddItemButton_Previews: PreviewProvider {
    static var previews: some View {
        AddItemButton()
    }
}
