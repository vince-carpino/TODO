import SwiftUI

struct StartEndTimeDecreaseButton: View {
    var action: () -> Void
    var isTargetTimeAtMinimum: Bool

    var body: some View {
        Button(action: action) {
            Image(systemName: "minus")
                .formatted(fontSize: 20, foregroundColor: isTargetTimeAtMinimum ? Color.clouds.opacity(0.25) : .clouds)
                .frame(width: 75, height: 75)
                .background(isTargetTimeAtMinimum ? Color.alizarin.opacity(0.25) : Color.alizarin)
                .cornerRadius(10)
        }
        .disabled(isTargetTimeAtMinimum)
    }
}

struct StartEndTimeDecreaseButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()

            StartEndTimeDecreaseButton(action: {}, isTargetTimeAtMinimum: false)
        }
    }
}
