import SwiftUI

struct TimelineListItemView: View {
    let timeBlockToShow: StoredTimeBlock
    let timeBlocksList: FetchedResults<StoredTimeBlock>

    var isLastTimeBlock: Bool {
        return timeBlockToShow == timeBlocksList.last
    }

    var body: some View {
        TimelineSeparator(hour: timeBlockToShow.startTime)

        HStack {
            Spacer()
                .frame(width: Constants.timelineSeparatorWidth)

            TimelineItem(storedTimeBlock: timeBlockToShow)
        }

        if isLastTimeBlock {
            TimelineSeparator(hour: timeBlockToShow.endTime)
        }
    }
}
