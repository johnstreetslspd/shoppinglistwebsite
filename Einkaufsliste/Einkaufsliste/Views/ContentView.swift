import SwiftUI

/// Root view with navigation, input area, and shopping list.
struct ContentView: View {
    @EnvironmentObject private var store: ShoppingListStore
    @State private var newItemText = ""
    @State private var selectedCategoryId: UUID?
    @State private var showCategorySheet = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Input area
                AddItemBar(
                    text: $newItemText,
                    selectedCategoryId: $selectedCategoryId,
                    categories: store.categories,
                    onAdd: addItem,
                    onManageCategories: { showCategorySheet = true }
                )

                // Stats bar
                StatsBar(
                    progressText: store.progressText,
                    itemCount: store.items.count,
                    hasDone: !store.doneItems.isEmpty,
                    onClearDone: {
                        hapticLight()
                        store.clearDone()
                    }
                )

                // List
                ShoppingListView()
            }
            .navigationTitle("🛒 Einkaufsliste")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showCategorySheet) {
                CategoryManagementView()
            }
        }
    }

    private func addItem() {
        let trimmed = newItemText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        hapticMedium()
        store.addItem(text: trimmed, categoryId: selectedCategoryId)
        newItemText = ""
    }

    private func hapticLight() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    private func hapticMedium() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}

// MARK: - Add Item Bar

struct AddItemBar: View {
    @Binding var text: String
    @Binding var selectedCategoryId: UUID?
    let categories: [Category]
    let onAdd: () -> Void
    let onManageCategories: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                TextField("Artikel hinzufügen…", text: $text)
                    .textFieldStyle(.roundedBorder)
                    .font(.body)
                    .submitLabel(.done)
                    .onSubmit(onAdd)

                Button(action: onAdd) {
                    Image(systemName: "plus")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }

            HStack(spacing: 10) {
                Picker("Kategorie", selection: $selectedCategoryId) {
                    Text("Keine Kategorie").tag(UUID?.none)
                    ForEach(categories) { cat in
                        Text(cat.name).tag(UUID?.some(cat.id))
                    }
                }
                .pickerStyle(.menu)
                .tint(.primary)

                Spacer()

                Button("Kategorien", action: onManageCategories)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.accentColor)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }
}

// MARK: - Stats Bar

struct StatsBar: View {
    let progressText: String
    let itemCount: Int
    let hasDone: Bool
    let onClearDone: () -> Void

    var body: some View {
        HStack {
            if itemCount > 0 {
                Text("\(itemCount) Artikel")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(progressText)
                .font(.caption)
                .foregroundStyle(.secondary)

            Spacer()

            if hasDone {
                Button("Erledigte löschen", action: onClearDone)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
    }
}

#Preview {
    ContentView()
        .environmentObject(ShoppingListStore())
}
