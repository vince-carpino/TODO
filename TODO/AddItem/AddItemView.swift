//
//  AddItemView.swift
//
//  Created by Vince Carpino on 5/11/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import SwiftUI

struct AddItemView: View {
    @Binding var itemName: String

    var body: some View {
        VStack {
            Text("Add an item")
                .font(.largeTitle)
                .bold()

            Spacer()

            VStack(alignment: .leading) {
                Text("Name")
                    .font(.title)
                    .bold()
                    .padding(.bottom, -10)

                TextField("Enter a name...", text: $itemName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            Spacer()

            VStack {
                Button(action: {
                    print("Add Item...")
                }) {
                    HStack {
                        Image(systemName: "plus")

                        Text("Add Item")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(40)
                }
                .disabled(self.itemName.isEmpty)

                Text("swipe down to cancel")
                    .foregroundColor(.gray)
                    .font(.footnote)
            }
        }
        .padding()
    }
}

 struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(itemName: Binding.constant("some value"))
    }
 }
