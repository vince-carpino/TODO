import SwiftUI

struct ItemPreviewOptionsView: View {
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .light))
                .edgesIgnoringSafeArea(.all)

            HStack() {
                ItemPreviewOption(isPresented: self.$isPresented, iconName: "checkmark.square.fill", label: "Mark as done", accentColor: .completedItemColor)

                Spacer()

                ItemPreviewOption(isPresented: self.$isPresented, iconName: "bolt.fill", label: "Set as current", accentColor: .currentItemColor)
            }
            .padding()
        }
        .transition(.opacity)
    }
}

struct ItemPreviewOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            RainbowViewVertical()

            ItemPreviewOptionsView(isPresented: Binding.constant(true))
        }
    }
}

struct ItemPreviewOption: View {
    @Binding var isPresented: Bool

    var iconName: String
    var label: String
    var accentColor: Color

    var body: some View {
        Button(action: {
            withAnimation {
                self.isPresented = false
            }
        }) {
            VStack {
                Image(systemName: iconName)
                    .frame(width: 75, height: 75)
                    .formatted(fontSize: 24)
                    .background(accentColor)
                    .clipShape(Circle())
                    .overlay(
                        Circle().strokeBorder(Color.clouds, lineWidth: 3)
                    )
                Text(label)
                    .formatted(fontSize: 20, foregroundColor: accentColor)
                    .padding(5)
                    .background(Color.clouds)
                    .cornerRadius(5)
            }
        }
    }
}
