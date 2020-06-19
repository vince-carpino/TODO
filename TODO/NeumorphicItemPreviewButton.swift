//
//  NeumorphicItemPreview.swift
//  TODO
//
//  Created by Vince Carpino on 6/12/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import SwiftUI

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct DarkButtonStyle<S: Shape>: ButtonStyle {
    var shape: S

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(shape)
            .background(
                DarkBackground(isHighlighted: configuration.isPressed, shape: shape)
            )
            .lineLimit(3)
            .truncationMode(.tail)
    }
}

struct SimpleButtonStyle<S: Shape>: ButtonStyle {
    var shape: S

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(shape)
            .background(
                Group {
                    if configuration.isPressed {
                        shape
                            .fill(Color.offWhite)
//                            .overlay(
//                                shape
//                                    .stroke(Color.gray, lineWidth: 4)
//                                    .blur(radius: 4)
//                                    .offset(x: 2, y: 2)
//                                    .mask(
//                                        shape
//                                            .fill(LinearGradient(.black, .clear))
//                                    )
//                            )
//                            .overlay(
//                                shape
//                                    .stroke(Color.white, lineWidth: 8)
//                                    .blur(radius: 4)
//                                    .offset(x: -2, y: -2)
//                                    .mask(
//                                        shape
//                                            .fill(LinearGradient(.clear, .black))
//                                    )
//                            )
                    } else {
                        shape
                            .fill(Color.offWhite)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    }
                }
            )
    }
}

struct DarkBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S

    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(.lightEnd, .lightStart))
                    .overlay(shape.stroke(LinearGradient(.lightStart, .lightEnd), lineWidth: 4))
            } else {
                shape
                    .fill(LinearGradient(.darkStart, .darkEnd))
                    .overlay(shape.stroke(LinearGradient(.lightStart, .lightEnd), lineWidth: 4))
                    .shadow(color: .darkStart, radius: 10, x: -10, y: -10)
                    .shadow(color: .darkEnd, radius: 10, x: 10, y: 10)
            }
        }
    }
}

struct LightBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S

    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(.lightEnd, .lightStart))
                    .overlay(shape.stroke(LinearGradient(.lightStart, .lightEnd), lineWidth: 4))
            } else {
                shape
                    .fill(LinearGradient(.darkStart, .darkEnd))
                    .overlay(shape.stroke(LinearGradient(.lightStart, .lightEnd), lineWidth: 4))
                    .shadow(color: .darkStart, radius: 10, x: -10, y: -10)
                    .shadow(color: .darkEnd, radius: 10, x: 10, y: 10)
            }
        }
    }
}

struct NeumorphicItemPreviewCard: View {
    var itemName: String

    private let cornerRadius: CGFloat = 25

    var body: some View {
        Button(action: {}) {
            Text(itemName)
                .font(.system(size: 25, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
                .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
                .lineLimit(3)
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.offWhite)
                        .foregroundColor(.black)
                        .frame(minWidth: 200, minHeight: 100)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                )
        }
        .padding()
    }
}

struct NeumorphicItemPreviewButton: View {
    var body: some View {
        ZStack {
            Color.offWhite

            Button(action: {}) {
                Buttons()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct NeumorphicItemPreview_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NeumorphicItemPreviewButton()

            ZStack {
                Color.offWhite
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 40) {
                    NeumorphicItemPreviewCard(itemName: "Vacuum room")
                    NeumorphicItemPreviewCard(itemName: "Some other big thing that has an equally big name so that it takes up a lot of space")
                }
            }
        }
    }
}
