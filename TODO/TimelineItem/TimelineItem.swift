import SwiftUI

struct TimelineItem: View {
    @Environment(\.managedObjectContext) var moc
    @State private var isPresentingAddEditView = false

    @ObservedObject var storedTimeBlock: StoredTimeBlock

    private let cornerRadius: CGFloat = 5
    private let baseHeight: CGFloat = 70

    var backgroundColor: Color {
        return Color.coreDataLegend.someKey(forValue: storedTimeBlock.colorName ?? "clear") ?? .clear
    }

    var calculatedHeight: CGFloat {
        return CGFloat(storedTimeBlock.endTime - storedTimeBlock.startTime) * baseHeight
    }

    var body: some View {
        Button(action: toggleAddEditView) {
            HStack {
                if storedTimeBlock.isUnused {
                    Image(systemName: "plus")
                }

                Text(storedTimeBlock.name?.uppercased() ?? "")
                    .bold()
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .formatted(fontSize: 20)
            .frame(maxWidth: .infinity, minHeight: calculatedHeight, maxHeight: calculatedHeight)
            .padding(10)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(Color.clouds, lineWidth: 5)
            )
        }
        .fullScreenCover(isPresented: $isPresentingAddEditView, content: {
            AddEditTimelineItemView(storedTimeBlock: storedTimeBlock).environment(\.managedObjectContext, moc)
        })
    }

    func toggleAddEditView() {
        isPresentingAddEditView.toggle()
    }
}

struct TimelineItem_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let storedTimeBlock = StoredTimeBlock(context: moc)
        storedTimeBlock.name = "First thing"
        storedTimeBlock.colorName = "alizarin"
        storedTimeBlock.startTime = 8
        storedTimeBlock.endTime = 9

        return ZStack {
            BackgroundView()

            TimelineItem(storedTimeBlock: storedTimeBlock)
        }
    }
}
