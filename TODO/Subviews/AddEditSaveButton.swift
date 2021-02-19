import SwiftUI

struct AddEditSaveButton: View {
    let action: () -> Void
    let backgroundColor: Color
    let disabledCondition: Bool

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "plus")

                Text("SAVE")
            }
            .formatted(fontSize: 20)
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(40)
        }
        .disabled(disabledCondition)
    }
}

struct AddEditSaveButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()

            AddEditSaveButton(action: {}, backgroundColor: .peterRiver, disabledCondition: false)
        }
    }
}
