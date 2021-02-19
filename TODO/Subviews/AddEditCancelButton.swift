import SwiftUI

struct AddEditCancelButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "xmark")

                Text("CANCEL")
            }
            .formatted(fontSize: 20)
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .overlay(RoundedRectangle(cornerRadius: 40)
                .stroke(Color.asbestos, lineWidth: 5)
            )
            .cornerRadius(40)
        }
    }
}

struct AddEditCancelButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()

            AddEditCancelButton(action: {})
        }
    }
}
