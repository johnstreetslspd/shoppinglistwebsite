import Foundation

/// A single item on the shopping list.
struct ShoppingItem: Identifiable, Codable, Equatable {
    let id: UUID
    var text: String
    var done: Bool
    var categoryId: UUID?

    init(id: UUID = UUID(), text: String, done: Bool = false, categoryId: UUID? = nil) {
        self.id = id
        self.text = text
        self.done = done
        self.categoryId = categoryId
    }
}
