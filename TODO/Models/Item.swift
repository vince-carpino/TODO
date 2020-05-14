//
//  Item.swift
//  TODO
//
//  Created by Vince Carpino on 5/11/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import Foundation

struct Item: Identifiable {
    var name: String
    var id: Int

    init() {
        self.name = "First item"
        self.id = 0
    }

    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
}
