import SwiftUI

struct TitleView: View {
    let text: String

    var body: some View {
        Text(text)
            .bold()
            .textCase(.uppercase)
            .formatted(fontSize: 45)
            .padding()
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()

            TitleView(text: "Example Title")
        }
    }
}
