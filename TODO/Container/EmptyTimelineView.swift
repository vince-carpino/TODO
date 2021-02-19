import SwiftUI

struct EmptyTimelineView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var isShowingAddEditTimelineItemView: Bool = false

    var body: some View {
        VStack {
            Spacer()

            Text("Nothing here...")
                .formatted(fontSize: 20)

            Spacer()

            Button(action: showAddEditView) {
                HStack {
                    Image(systemName: "plus")

                    Text("ADD")
                }
                .formatted(fontSize: 20)
                .padding()
            }
            .background(Color.peterRiver)
            .cornerRadius(5)
            .fullScreenCover(isPresented: $isShowingAddEditTimelineItemView, content: {
                AddFirstTimelineItemView().environment(\.managedObjectContext, moc)
            })
        }
    }

    func showAddEditView() {
        self.isShowingAddEditTimelineItemView.toggle()
    }
}

struct EmptyTimelineView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()

            EmptyTimelineView()
        }
    }
}
