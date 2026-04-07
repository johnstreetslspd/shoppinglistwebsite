import Foundation
import SwiftUI

/// Central store that manages items and categories with UserDefaults persistence.
@MainActor
final class ShoppingListStore: ObservableObject {

    // MARK: - Published state

    @Published var items: [ShoppingItem] = []
    @Published var categories: [Category] = []

    // MARK: - Storage keys

    private let itemsKey = "shopping-list-v1"
    private let categoriesKey = "shopping-categories-v1"

    // MARK: - Init

    init() {
        loadItems()
        loadCategories()
    }

    // MARK: - Persistence

    private func loadItems() {
        guard let data = UserDefaults.standard.data(forKey: itemsKey),
              let decoded = try? JSONDecoder().decode([ShoppingItem].self, from: data) else { return }
        items = decoded
    }

    private func loadCategories() {
        guard let data = UserDefaults.standard.data(forKey: categoriesKey),
              let decoded = try? JSONDecoder().decode([Category].self, from: data) else { return }
        categories = decoded
    }

    private func saveItems() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: itemsKey)
        }
    }

    private func saveCategories() {
        if let data = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(data, forKey: categoriesKey)
        }
    }

    // MARK: - Computed helpers

    var openItems: [ShoppingItem] { items.filter { !$0.done } }
    var doneItems: [ShoppingItem] { items.filter { $0.done } }

    var progressText: String {
        let total = items.count
        let doneCount = doneItems.count
        if total == 0 { return "Deine Liste ist leer" }
        if doneCount == total { return "🎉 Alles erledigt!" }
        return "\(doneCount) von \(total) erledigt"
    }

    /// Returns open items grouped by category in priority order, with uncategorised last.
    var groupedOpenItems: [(category: Category?, items: [ShoppingItem])] {
        guard !categories.isEmpty else {
            return openItems.isEmpty ? [] : [(nil, openItems)]
        }

        var groups: [(Category?, [ShoppingItem])] = categories.map { cat in
            (cat, openItems.filter { $0.categoryId == cat.id })
        }

        let uncategorised = openItems.filter { item in
            item.categoryId == nil || !categories.contains(where: { $0.id == item.categoryId })
        }

        // Remove empty category groups
        groups = groups.filter { !$0.1.isEmpty }

        if !uncategorised.isEmpty {
            groups.append((nil, uncategorised))
        }

        return groups
    }

    // MARK: - Item actions

    func addItem(text: String, categoryId: UUID?) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let item = ShoppingItem(text: trimmed, categoryId: categoryId)
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            items.insert(item, at: 0)
        }
        saveItems()
    }

    func toggleDone(_ item: ShoppingItem) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            items[idx].done.toggle()
        }
        saveItems()
    }

    func deleteItem(_ item: ShoppingItem) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
            items.removeAll { $0.id == item.id }
        }
        saveItems()
    }

    func clearDone() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            items.removeAll { $0.done }
        }
        saveItems()
    }

    // MARK: - Category actions

    func addCategory(name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let cat = Category(name: trimmed)
        withAnimation {
            categories.append(cat)
        }
        saveCategories()
    }

    func deleteCategory(_ cat: Category) {
        // Clear category from items
        for idx in items.indices where items[idx].categoryId == cat.id {
            items[idx].categoryId = nil
        }
        withAnimation {
            categories.removeAll { $0.id == cat.id }
        }
        saveItems()
        saveCategories()
    }

    func moveCategory(from source: IndexSet, to destination: Int) {
        withAnimation {
            categories.move(fromOffsets: source, toOffset: destination)
        }
        saveCategories()
    }

    func moveCategoryUp(_ index: Int) {
        guard index > 0 else { return }
        withAnimation {
            categories.swapAt(index, index - 1)
        }
        saveCategories()
    }

    func moveCategoryDown(_ index: Int) {
        guard index < categories.count - 1 else { return }
        withAnimation {
            categories.swapAt(index, index + 1)
        }
        saveCategories()
    }

    func category(for id: UUID?) -> Category? {
        guard let id else { return nil }
        return categories.first(where: { $0.id == id })
    }
}
