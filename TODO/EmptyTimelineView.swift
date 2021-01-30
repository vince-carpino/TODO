//
//  EmptyTimelineView.swift
//  TODO
//
//  Created by Vince Carpino on 1/29/21.
//  Copyright © 2021 Vince Carpino. All rights reserved.
//

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

            Button(action: {
                self.isShowingAddEditTimelineItemView.toggle()
            }) {
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
}

struct EmptyTimelineView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()

            EmptyTimelineView()
        }
    }
}
