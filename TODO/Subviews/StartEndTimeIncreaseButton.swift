import SwiftUI

struct StartEndTimeIncreaseButton: View {
    var action: () -> Void
    var isTargetTimeAtMaximum: Bool

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .formatted(fontSize: 20, foregroundColor: isTargetTimeAtMaximum ? Color.clouds.opacity(0.25) : .clouds)
                .frame(width: 75, height: 75)
                .background(isTargetTimeAtMaximum ? Color.greenSea.opacity(0.25) : .greenSea)
                .cornerRadius(10)
        }
        .disabled(isTargetTimeAtMaximum)
    }
}

struct StartEndTimeIncreaseButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()

            StartEndTimeIncreaseButton(action: {}, isTargetTimeAtMaximum: false)
        }
    }
}
