//
//  AddItemView.swift
//
//  Created by Vince Carpino on 5/11/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    @State private var itemName = ""
//    @State private var itemName: String = ""
//    @Binding var isPresented: Bool
//    @Binding var itemsList: [Item]

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
                    .keyboardType(.default)
            }

            Spacer()

            VStack {
                Button(action: {
//                    print("\n\nAdd New Item...")
                    self.addNewItem()
//                    self.isPresented = false
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "plus")

                        Text("Add Item")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(buttonColor)
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

    var buttonColor: Color {
        return self.itemName.isEmpty ? .gray : .blue
    }

    fileprivate func addNewItem() {
        let item = Item(context: self.moc)
        item.id = UUID()
        item.name = self.itemName

        do {
            try self.moc.save()
        } catch {
            print("THERE WAS AN ERROR SAVING ITEM")
        }



//        print("\n\nAdd new item start: \(self.itemsList)")
//        let newItem = Item(name: self.itemName, id: UserDefaults.incrementAndReturnLatestItemId())
//        self.itemsList.append(newItem)
//        print("\n\nAdd new item after append: \(self.itemsList)")

//        if let savedItemList = UserDefaults.standard.object(forKey: Constants.ItemsListKey) as? Data {
//            let decoder = JSONDecoder()
//            if var loadedList = try? decoder.decode([Item].self, from: savedItemList) {
//                loadedList.append(newItem)
//
//                let encoder = JSONEncoder()
//                if let encodedList = try? encoder.encode(loadedList) {
//                    UserDefaults.standard.set(encodedList, forKey: Constants.ItemsListKey)
//                    print("\n\nAdd new item encoded list at end: \(encodedList)")
//                }
//            }
//        } else {
//            let encoder = JSONEncoder()
//            if let encodedList = try? encoder.encode(self.itemsList) {
//                UserDefaults.standard.set(encodedList, forKey: Constants.ItemsListKey)
//                print("\n\nAdd new item encoded list at end: \(encodedList)")
//            }
//        }

//        var savedItemsList = UserDefaults.standard.object(forKey: Constants.ItemsListKey) as? [Item] ?? [Item]()
//        savedItemsList.append(newItem)
//        let encoder = JSONEncoder()
//        if let encodedList = try? encoder.encode(self.itemsList) {
//            UserDefaults.standard.set(encodedList, forKey: Constants.ItemsListKey)
//            print("\n\nAdd new item encoded list at end: \(encodedList)")
//        }
    }
}

//extension UserDefaults {
//    class func getLatestItemId() -> Int {
//        return standard.integer(forKey: Constants.LatestItemIdKey)
//    }
//
//    class func incrementAndReturnLatestItemId() -> Int {
//        let newNewestItemId = self.getLatestItemId() + 1
//        standard.set(newNewestItemId, forKey: Constants.LatestItemIdKey)
//
//        return newNewestItemId
//    }
//}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
