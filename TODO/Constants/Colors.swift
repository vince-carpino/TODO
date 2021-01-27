//
//  Colors.swift
//  TODO
//
//  Created by Vince Carpino on 5/19/20.
//  Copyright © 2020 Vince Carpino. All rights reserved.
//

import SwiftUI

extension Color {
    public static let alizarin = Color(#colorLiteral(red: 0.9058824182, green: 0.2980392277, blue: 0.2352941334, alpha: 1))
    public static let pomegranate = Color(#colorLiteral(red: 0.7529412508, green: 0.2235294282, blue: 0.1686274558, alpha: 1))

    public static let carrot = Color(#colorLiteral(red: 0.9019608498, green: 0.4941176772, blue: 0.1333333403, alpha: 1))
    public static let pumpkin = Color(#colorLiteral(red: 0.8274510503, green: 0.3294117749, blue: 0, alpha: 1))

    public static let sunFlower = Color(#colorLiteral(red: 0.9450981021, green: 0.7686275244, blue: 0.05882353336, alpha: 1))
    public static let clementine = Color(#colorLiteral(red: 0.9529412389, green: 0.611764729, blue: 0.07058823854, alpha: 1))

    public static let emerland = Color(#colorLiteral(red: 0.180392161, green: 0.8000000715, blue: 0.4431372881, alpha: 1))
    public static let nephritis = Color(#colorLiteral(red: 0.1529411823, green: 0.6823529601, blue: 0.3764706254, alpha: 1))

    public static let turquoise = Color(#colorLiteral(red: 0.1019607843, green: 0.7372549176, blue: 0.611764729, alpha: 1))
    public static let greenSea = Color(#colorLiteral(red: 0.08627451211, green: 0.6274510026, blue: 0.521568656, alpha: 1))

    public static let peterRiver = Color(#colorLiteral(red: 0.2039215863, green: 0.5960784554, blue: 0.8588235974, alpha: 1))
    public static let belizeHole = Color(#colorLiteral(red: 0.160784319, green: 0.501960814, blue: 0.7254902124, alpha: 1))

    public static let amethyst = Color(#colorLiteral(red: 0.6078431606, green: 0.3490196168, blue: 0.7137255073, alpha: 1))
    public static let wisteria = Color(#colorLiteral(red: 0.5568627715, green: 0.2666666806, blue: 0.6784313917, alpha: 1))

    public static let wetAsphalt = Color(#colorLiteral(red: 0.2039215863, green: 0.2862745225, blue: 0.3686274588, alpha: 1))
    public static let midnightBlue = Color(#colorLiteral(red: 0.1725490242, green: 0.2431372702, blue: 0.3137255013, alpha: 1))

    public static let concrete = Color(#colorLiteral(red: 0.5843137503, green: 0.6470588446, blue: 0.650980413, alpha: 1))
    public static let asbestos = Color(#colorLiteral(red: 0.4980392456, green: 0.5490196347, blue: 0.5529412031, alpha: 1))

    public static let clouds = Color(#colorLiteral(red: 0.9254902601, green: 0.9411765337, blue: 0.9450981021, alpha: 1))
    public static let silver = Color(#colorLiteral(red: 0.741176486, green: 0.764705956, blue: 0.7803922296, alpha: 1))

    public static let currentItemColor: Color = .amethyst
    public static let completedItemColor: Color = .silver
    public static let incompleteItemColor: Color = .greenSea

    public static let backgroundColor: Color = .midnightBlue

    public static let unusedTimeBlockColor: Color = .clear
    public static let defaultTimeBlockColor: Color = .clear

    public static let coreDataLegend: [Color: String] = [
        .alizarin: "alizarin",
        .pomegranate: "pomegranate",
        .carrot: "carrot",
        .pumpkin: "pumpkin",
        .sunFlower: "sunFlower",
        .clementine: "clementine",
        .emerland: "emerland",
        .nephritis: "nephritis",
        .turquoise: "turquoise",
        .greenSea: "greenSea",
        .peterRiver: "peterRiver",
        .belizeHole: "belizeHole",
        .amethyst: "amethyst",
        .wisteria: "wisteria",
        .wetAsphalt: "wetAsphalt",
        .midnightBlue: "midnightBlue",
        .concrete: "concrete",
        .asbestos: "asbestos",
        .clouds: "clouds",
        .silver: "silver",
        .clear: "clear",
    ]
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
