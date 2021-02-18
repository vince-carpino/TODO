import SwiftUI

struct TimelineItemPreview: View {
    var name: Binding<String>
    var color: Binding<Color>

    private let cornerRadius: CGFloat = 5
    private let baseHeight: CGFloat = 70

    var body: some View {
        HStack {
            Text(name.wrappedValue.uppercased())
                .bold()
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .formatted(fontSize: 20)
        .frame(maxWidth: .infinity, minHeight: baseHeight, maxHeight: baseHeight)
        .padding(10)
        .background(color.wrappedValue)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(Color.clouds, lineWidth: 5)
        )
    }
}

struct TimelineItemPreview_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()

            TimelineItemPreview(name: Binding.constant("Item name"), color: Binding.constant(Color.turquoise))
        }
    }
}
