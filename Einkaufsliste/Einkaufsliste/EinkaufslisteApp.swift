import SwiftUI

@main
struct EinkaufslisteApp: App {
    @StateObject private var store = ShoppingListStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
