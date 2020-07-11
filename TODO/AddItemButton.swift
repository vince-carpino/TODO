//
//  AddItemButton.swift
//  TODO
//
//  Created by Vince Carpino on 5/12/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import SwiftUI

struct AddItemButton: View {
    @Environment(\.managedObjectContext) var moc

    @Binding var isPresentingQuickAddItemView: Bool
    
    @State private var isPresentingAddItemView = false

    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: "plus.square")
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(.clouds)

                Text("new item")
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .bold()
                    .foregroundColor(.clouds)
                    .cornerRadius(10)
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.peterRiver)
            .cornerRadius(10)
            .shadow(radius: 10)
            .onTapGesture {
                print("in onTapGesture")
                withAnimation {
                    self.isPresentingQuickAddItemView = true
                }
            }
            .onLongPressGesture {
                print("LONG PRESSED")
                self.isPresentingAddItemView = true
            }
        }
        .sheet(isPresented: $isPresentingAddItemView) {
            AddEditItemView(item: nil).environment(\.managedObjectContext, self.moc)
        }
    }
}

struct AddItemButton_Previews: PreviewProvider {
    static var previews: some View {
        AddItemButton(isPresentingQuickAddItemView: Binding.constant(false))
            .padding()
    }
}
