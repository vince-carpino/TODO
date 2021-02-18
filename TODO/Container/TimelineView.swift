import CoreData
import SwiftUI

struct TimelineView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: StoredTimeBlock.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \StoredTimeBlock.startTime, ascending: true)
    ]) var timeBlocksCoreData: FetchedResults<StoredTimeBlock>

    private let timelineSeparatorWidth: CGFloat = 65

    var body: some View {
        ZStack {
            BackgroundView()

            VStack {
                Text("TODAY")
                    .formatted(fontSize: 36)

                if timeBlocksCoreData.count == 0 {
                    EmptyTimelineView()
                } else {
                    ScrollView(showsIndicators: false) {
                        ZStack {
                            VStack(spacing: 0) {
                                ForEach(timeBlocksCoreData, id: \.id) { timeBlock in
                                    TimelineSeparator(hour: timeBlock.startTime)

                                    HStack {
                                        Spacer()
                                            .frame(width: timelineSeparatorWidth)

                                        TimelineItem(storedTimeBlock: timeBlock)
                                    }

                                    if timeBlock == timeBlocksCoreData.last {
                                        TimelineSeparator(hour: timeBlock.endTime)
                                    }
                                }

                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                }
            }
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let storedTimeBlock = StoredTimeBlock(context: moc)
        storedTimeBlock.name = "First thing"
        storedTimeBlock.colorName = "alizarin"
        storedTimeBlock.startTime = 8
        storedTimeBlock.endTime = 9

        return TimelineView().environment(\.managedObjectContext, moc)
    }
}
