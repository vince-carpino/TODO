//
//  AddItemView.swift
//
//  Created by Vince Carpino on 5/11/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import SwiftUI

struct AddItemView: View {
    @State var itemName: String

    var body: some View {
        VStack {
            Text("Add an item")
                .font(.largeTitle)

            Spacer()

            VStack(alignment: .leading) {
                Text("Name")
                    .font(.callout)
                    .bold()
                    .padding(.bottom, -10)

                TextField("Enter a name...", text: $itemName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            Spacer()

            HStack {
                Button(action: {
                    print("Cancel...")
                }) {
                    HStack {
                        Image(systemName: "xmark")

                        Text("Cancel")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(.red)
                    .background(Color.white)
                    .cornerRadius(40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.red, lineWidth: 3)
                    )
                }

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
            }
        }
        .padding()
    }
}

 struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(itemName: "some value")
    }
 }
