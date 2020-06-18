//
//  Buttons.swift
//  TODO
//
//  Created by Vince Carpino on 6/15/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import SwiftUI

struct Buttons: View {
    private let foregroundColor = Color(#colorLiteral(red: 0.8095483356, green: 0.8423705739, blue: 1, alpha: 1))
    @State private var tapped = false
    @GestureState private var tap = false

    var body: some View {
//        ZStack {
//            Color.offWhite
//                .edgesIgnoringSafeArea(.all)

        Text("Vacuum room")
            .font(.system(size: 20, weight: .semibold, design: .rounded))
            .padding(20)
            .foregroundColor(.black)
            .background(
                ZStack {
                    foregroundColor

                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .foregroundColor(.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)

                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(LinearGradient(Color.clouds, .white))
                        .padding(2)
                        .blur(radius: 2)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: foregroundColor, radius: 20, x: 20, y: 20)
            .shadow(color: Color.white, radius: 20, x: -20, y: -20)
            .scaleEffect(tap ? 1.2 : 1)
//            .gesture(
//                LongPressGesture()
//                    .updating($tap) { value, state, _ in
//                        state = value
//                    }
//            )
            .onLongPressGesture {
                print("LONG PRESS")
            }
//        }
    }
}

struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.offWhite
                .edgesIgnoringSafeArea(.all)

            Buttons()
        }
    }
}
