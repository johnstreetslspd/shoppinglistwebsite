import SwiftUI

/// Displays the shopping list with grouped open items and a done section.
struct ShoppingListView: View {
    @EnvironmentObject private var store: ShoppingListStore

    var body: some View {
        List {
            if store.items.isEmpty {
                EmptyStateView()
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            } else {
                // Open items grouped by category
                let groups = store.groupedOpenItems
                if !groups.isEmpty {
                    Section {
                        ForEach(groups, id: \.category?.id) { group in
                            if let cat = group.category {
                                let idx = store.categories.firstIndex(where: { $0.id == cat.id }) ?? 0
                                CategoryHeaderView(name: cat.name, priority: idx + 1)
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
                                    .listRowBackground(Color.clear)
                            } else if store.categories.count > 0 {
                                CategoryHeaderView(name: "Sonstige", priority: nil)
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
                                    .listRowBackground(Color.clear)
                            }
                            ForEach(group.items) { item in
                                ShoppingItemRow(item: item)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            hapticLight()
                                            store.deleteItem(item)
                                        } label: {
                                            Label("Löschen", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                    } header: {
                        Text("Noch zu kaufen")
                            .font(.caption.weight(.semibold))
                            .textCase(.uppercase)
                            .foregroundStyle(.secondary)
                    }
                }

                // Done items
                if !store.doneItems.isEmpty {
                    Section {
                        ForEach(store.doneItems) { item in
                            ShoppingItemRow(item: item)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        hapticLight()
                                        store.deleteItem(item)
                                    } label: {
                                        Label("Löschen", systemImage: "trash")
                                    }
                                }
                        }
                    } header: {
                        Text("Erledigt")
                            .font(.caption.weight(.semibold))
                            .textCase(.uppercase)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollDismissesKeyboard(.interactively)
    }

    private func hapticLight() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

// MARK: - Shopping Item Row

struct ShoppingItemRow: View {
    @EnvironmentObject private var store: ShoppingListStore
    let item: ShoppingItem

    var body: some View {
        Button {
            hapticSelection()
            store.toggleDone(item)
        } label: {
            HStack(spacing: 14) {
                // Checkbox
                ZStack {
                    Circle()
                        .strokeBorder(item.done ? Color.accentColor : Color(.systemGray4), lineWidth: 2)
                        .frame(width: 26, height: 26)

                    if item.done {
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 26, height: 26)

                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: item.done)

                // Text
                Text(item.text)
                    .font(.body)
                    .foregroundStyle(item.done ? .secondary : .primary)
                    .strikethrough(item.done, color: .secondary)
                    .animation(.easeInOut(duration: 0.2), value: item.done)

                Spacer()
            }
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
    }

    private func hapticSelection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}

// MARK: - Category Header

struct CategoryHeaderView: View {
    let name: String
    let priority: Int?

    var body: some View {
        HStack(spacing: 8) {
            if let priority {
                Text("\(priority)")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 22, height: 22)
                    .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 6))
            }

            Text(name)
                .font(.caption.weight(.semibold))
                .textCase(.uppercase)
                .tracking(0.6)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Empty State

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "cart")
                .font(.system(size: 48))
                .foregroundStyle(.tertiary)

            Text("Keine Artikel")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Füge oben etwas hinzu")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

#Preview {
    NavigationStack {
        ShoppingListView()
            .environmentObject(ShoppingListStore())
    }
}
