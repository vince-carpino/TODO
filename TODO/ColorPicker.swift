import SwiftUI

struct ColorPicker: View {
    @Binding var selectedColor: Color

    private let colors: [Color] = [
        .alizarin,
        .carrot,
        .sunFlower,
        .nephritis,
        .peterRiver,
        .amethyst,
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(colors, id: \.self) { color in
                Button(action: {
                    selectedColor = color
                }) {
                    ZStack {
                        if color == selectedColor {
                            Rectangle()
                                .foregroundColor(color)
                                .overlay(Rectangle()
                                    .strokeBorder(Color.clouds, lineWidth: 4))
                        } else {
                            Rectangle()
                                .foregroundColor(color)
                        }

                        if color == selectedColor {
                            Image(systemName: "checkmark")
                                .formatted(fontSize: 18)
                        }
                    }
                }
            }
        }
        .frame(height: 50)
        .cornerRadius(5)
    }
}

struct ColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()

            ColorPicker(selectedColor: Binding.constant(Color.alizarin))
        }
    }
}
