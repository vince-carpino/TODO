import SwiftUI

struct QuickAddItemView: View {
    @Environment(\.managedObjectContext) var moc

    @Binding var isPresented: Bool

    @State private var itemName = "Item name"

    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .light))
                .edgesIgnoringSafeArea(.all)

            VStack {
                TextField("Enter a name...", text: $itemName)
                    .formatted(fontSize: 24)
                    .padding(15)
                    .background(Color.incompleteItemColor)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.clouds, lineWidth: 5)
                    )

                HStack {
                    Button(action: {
                        print("--- DONE ---")
                        self.hideKeyboard()
                        withAnimation {
                            self.isPresented = false
                        }
                    }) {
                        HStack {
                            Image(systemName: "checkmark")

                            Text("Done")
                        }
                        .padding(12)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color.midnightBlue)
                        .foregroundColor(.clouds)
                        .cornerRadius(10)
                    }

                    Button(action: {
                        print("--- ADD ---")
                        print("ADDED \(self.itemName)")
                        self.addNewItem()
                        self.itemName = ""
                    }) {
                        HStack {
                            Image(systemName: "plus")

                            Text("Add")
                        }
                        .padding(12)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(self.nameFieldIsEmpty() ? Color.silver : Color.peterRiver)
                        .foregroundColor(self.nameFieldIsEmpty() ? .concrete : .clouds)
                        .cornerRadius(10)
                    }
                    .disabled(nameFieldIsEmpty())
                }
                .font(.system(size: 16, weight: .semibold, design: .rounded))
            }
            .onAppear {
                self.itemName = ""
            }
            .padding()
        }
    }

    fileprivate func nameFieldIsEmpty() -> Bool {
        return self.itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    fileprivate func addNewItem() {
        let item = Item(context: self.moc)
        item.id = UUID()
        item.name = self.itemName
        item.creationTime = Date()
        item.hasBeenDeleted = false
        item.isCompleted = false
        item.hasDueDate = false
        item.hasDueTime = false

        self.saveContext()
    }

    fileprivate func saveContext() {
        do {
            try self.moc.save()
        } catch {
            print("Error while saving item:\n***\n\(error)\n***")
        }
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = self.effect }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct QuickAddItemView_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let oneDayInSeconds = Double(24 * 60 * 60)

        let item1 = Item(context: moc)
        item1.id = UUID()
        item1.name = "Wash car"
        item1.creationTime = Date()
        item1.dueDate = Date()

        let item2 = Item(context: moc)
        item2.id = UUID()
        item2.name = "Should not be seen"
        item2.creationTime = Date()
        item2.hasBeenDeleted = true
        item2.dueDate = Date().advanced(by: 1 * oneDayInSeconds)

        let item3 = Item(context: moc)
        item3.id = UUID()
        item3.name = "Throw in laundry"
        item3.creationTime = Date()
        item3.dueDate = Date().advanced(by: -2 * oneDayInSeconds)

        let item4 = Item(context: moc)
        item4.id = UUID()
        item4.name = String(repeating: "Just a really long name ", count: 5)
        item4.creationTime = Date()
        item4.dueDate = Date().advanced(by: 3 * oneDayInSeconds)

        return ZStack {
            RainbowViewHorizontal()

            ItemScrollView().environment(\.managedObjectContext, moc)

            QuickAddItemView(isPresented: Binding.constant(true)).environment(\.managedObjectContext, moc)
        }
    }
}

struct RainbowViewHorizontal: View {
    var body: some View {
        HStack(spacing: 0) {
            Color.alizarin
            Color.carrot
            Color.sunFlower
            Color.emerland
            Color.turquoise
            Color.peterRiver
            Color.amethyst
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct RainbowViewVertical: View {
    var body: some View {
        VStack(spacing: 0) {
            Color.alizarin
            Color.carrot
            Color.sunFlower
            Color.emerland
            Color.turquoise
            Color.peterRiver
            Color.amethyst
        }
        .edgesIgnoringSafeArea(.all)
    }
}
