import SwiftUI

struct AddItemButton: View {
    @Environment(\.managedObjectContext) var moc

    @Binding var isPresentingQuickAddItemView: Bool
    
    @State private var isPresentingAddItemView = false

    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: "plus.square")

                Text("new item")
                    .bold()
                    .cornerRadius(10)
            }
            .formatted(fontSize: 24)
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.peterRiver)
            .cornerRadius(10)
            .shadow(radius: 10)
            .onTapGesture {
                withAnimation {
                    self.isPresentingQuickAddItemView = true
                }
            }
            .onLongPressGesture {
                self.isPresentingAddItemView = true
            }
        }
        .sheet(isPresented: $isPresentingAddItemView) {
            AddEditItemView(item: nil).environment(\.managedObjectContext, self.moc)
        }
    }
}

struct AddItemButton_Previews: PreviewProvider {
    static var previews: some View {
        AddItemButton(isPresentingQuickAddItemView: Binding.constant(false))
            .padding()
    }
}
