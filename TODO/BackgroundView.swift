//
//  BackgroundView.swift
//  TODO
//
//  Created by Vince Carpino on 1/29/21.
//  Copyright © 2021 Vince Carpino. All rights reserved.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Color.backgroundColor
            .edgesIgnoringSafeArea(.all)
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
