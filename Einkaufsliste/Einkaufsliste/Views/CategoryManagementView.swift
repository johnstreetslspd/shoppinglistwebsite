import SwiftUI

/// Sheet for managing categories: add, delete, and reorder.
struct CategoryManagementView: View {
    @EnvironmentObject private var store: ShoppingListStore
    @Environment(\.dismiss) private var dismiss
    @State private var newCategoryName = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if store.categories.isEmpty {
                    emptyCategoryState
                } else {
                    categoryList
                }

                Divider()

                addCategoryBar
            }
            .navigationTitle("Kategorien")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fertig") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    // MARK: - Empty State

    private var emptyCategoryState: some View {
        VStack(spacing: 12) {
            Image(systemName: "folder.badge.plus")
                .font(.system(size: 40))
                .foregroundStyle(.tertiary)

            Text("Noch keine Kategorien")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Füge welche hinzu!")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Category List

    private var categoryList: some View {
        List {
            ForEach(Array(store.categories.enumerated()), id: \.element.id) { index, cat in
                HStack(spacing: 12) {
                    // Priority badge
                    Text("\(index + 1)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 26, height: 26)
                        .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 7))

                    // Name
                    Text(cat.name)
                        .font(.body)

                    Spacer()

                    // Move buttons
                    HStack(spacing: 4) {
                        Button {
                            hapticLight()
                            store.moveCategoryUp(index)
                        } label: {
                            Image(systemName: "chevron.up")
                                .font(.caption.weight(.semibold))
                                .frame(width: 32, height: 32)
                                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                        .disabled(index == 0)

                        Button {
                            hapticLight()
                            store.moveCategoryDown(index)
                        } label: {
                            Image(systemName: "chevron.down")
                                .font(.caption.weight(.semibold))
                                .frame(width: 32, height: 32)
                                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                        .disabled(index == store.categories.count - 1)
                    }

                    // Delete button
                    Button(role: .destructive) {
                        hapticLight()
                        store.deleteCategory(cat)
                    } label: {
                        Image(systemName: "xmark")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.red)
                            .frame(width: 32, height: 32)
                            .background(Color.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
            }
            .onMove { source, destination in
                store.moveCategory(from: source, to: destination)
            }
        }
        .listStyle(.insetGrouped)
    }

    // MARK: - Add Category Bar

    private var addCategoryBar: some View {
        HStack(spacing: 10) {
            TextField("Neue Kategorie…", text: $newCategoryName)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.done)
                .onSubmit(addCategory)

            Button(action: addCategory) {
                Text("Hinzufügen")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
        }
        .padding()
    }

    // MARK: - Actions

    private func addCategory() {
        let trimmed = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        hapticMedium()
        store.addCategory(name: trimmed)
        newCategoryName = ""
    }

    private func hapticLight() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    private func hapticMedium() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}

#Preview {
    CategoryManagementView()
        .environmentObject(ShoppingListStore())
}
