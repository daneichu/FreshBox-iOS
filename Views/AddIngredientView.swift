import SwiftUI
import CoreData

struct AddIngredientView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var quantity = ""
    @State private var expiryDate = Date()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("재료 정보")) {
                    TextField("재료명", text: $name)
                    TextField("수량 예: 10개", text: $quantity)
                    DatePicker("유통기한", selection: $expiryDate, displayedComponents: .date)
                }
            }
            .navigationTitle("재료 추가")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        saveIngredient()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func saveIngredient() {
        let newIngredient = Ingredient(context: viewContext)
        newIngredient.id = UUID()
        newIngredient.name = name
        newIngredient.quantity = quantity
        newIngredient.expiryDate = expiryDate
        newIngredient.createdAt = Date()

        do {
            try viewContext.save()

            NotificationService.scheduleExpiryNotification(
                for: name,
                dDay: 3
            )

            dismiss()
        } catch {
            print("재료 저장 실패: \(error.localizedDescription)")
        }
    }
}
