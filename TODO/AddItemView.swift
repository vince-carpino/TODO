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
            Text("Let's add a new thing")
                .font(.largeTitle)

            VStack(alignment: .leading) {
                Text("Name")
                    .font(.callout)
                    .bold()

                TextField("Enter a name...", text: $itemName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            Spacer()

            HStack {
                Button(action: {
                    print("Cancel...")
                }) {
                    Text("Cancel")
                        .bold()
                        .padding(10)
                        .padding([.leading, .trailing], 30)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(.gray)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 3)
                        )
                }

                Button(action: {
                    print("Add Item...")
                }) {
                    Text("Add Item")
                        .bold()
                        .padding(.all, 10)
                        .padding([.leading, .trailing], 30)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(20)
                }
            }
        }
        .padding()
    }
}

// struct AddItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddItemView(itemName: "some value")
//    }
// }
