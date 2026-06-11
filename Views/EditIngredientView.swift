import SwiftUI
import CoreData

struct EditIngredientView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    let ingredient: Ingredient

    @State private var name: String
    @State private var quantity: String
    @State private var expiryDate: Date

    init(ingredient: Ingredient) {
        self.ingredient = ingredient
        _name = State(initialValue: ingredient.name ?? "")
        _quantity = State(initialValue: ingredient.quantity ?? "")
        _expiryDate = State(initialValue: ingredient.expiryDate ?? Date())
    }

    var body: some View {
        Form {
            Section(header: Text("재료 수정")) {
                TextField("재료명", text: $name)
                TextField("수량 예: 8개, 200g", text: $quantity)
                DatePicker("유통기한", selection: $expiryDate, displayedComponents: .date)
            }

            Button("수정 완료") {
                updateIngredient()
            }
            .fontWeight(.bold)
        }
        .navigationTitle("재료 수정")
    }

    private func updateIngredient() {
        ingredient.name = name
        ingredient.quantity = quantity
        ingredient.expiryDate = expiryDate

        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("재료 수정 실패: \(error.localizedDescription)")
        }
    }
}
