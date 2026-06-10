import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isShowingAddIngredient = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Ingredient.expiryDate, ascending: true)],
        animation: .default
    )
    private var ingredients: FetchedResults<Ingredient>

    var body: some View {
        NavigationView {
            VStack {
                if ingredients.isEmpty {
                    VStack(spacing: 16) {
                        Text("🧊")
                            .font(.system(size: 60))
                        
                        Text("냉장고가 비어 있어요")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("재료를 추가하면 유통기한을 관리할 수 있어요.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                } else {
                    List {
                        ForEach(ingredients) { ingredient in
                            HStack(spacing: 12) {
                                Text(ingredientEmoji(for: ingredient.name))
                                    .font(.title2)

                                VStack(alignment: .leading, spacing: 6) {
                                    Text(ingredient.name ?? "이름 없음")
                                        .font(.headline)

                                    Text(ingredient.quantity ?? "")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                Text(dDayText(for: ingredient.expiryDate))
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(dDayColor(for: ingredient.expiryDate).opacity(0.2))
                                    .foregroundColor(dDayColor(for: ingredient.expiryDate))
                                    .cornerRadius(18)
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: deleteIngredients)
                    }
                }
            }
            .navigationTitle("내 냉장고")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingAddIngredient = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddIngredient) {
                AddIngredientView()
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }

    private func deleteIngredients(offsets: IndexSet) {
        withAnimation {
            offsets.map { ingredients[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                print("삭제 실패: \(error.localizedDescription)")
            }
        }
    }

    private func dDayText(for date: Date?) -> String {
        guard let date = date else { return "D-?" }

        let today = Calendar.current.startOfDay(for: Date())
        let expiry = Calendar.current.startOfDay(for: date)
        let days = Calendar.current.dateComponents([.day], from: today, to: expiry).day ?? 0

        if days == 0 {
            return "D-Day"
        } else if days > 0 {
            return "D-\(days)"
        } else {
            return "D+\(-days)"
        }
    }

    private func dDayColor(for date: Date?) -> Color {
        guard let date = date else { return .gray }

        let today = Calendar.current.startOfDay(for: Date())
        let expiry = Calendar.current.startOfDay(for: date)
        let days = Calendar.current.dateComponents([.day], from: today, to: expiry).day ?? 0

        if days <= 3 {
            return .red
        } else if days <= 7 {
            return .orange
        } else {
            return .green
        }
    }
    
    private func ingredientEmoji(for name: String?) -> String {
        let name = name ?? ""

        if name.contains("달걀") || name.contains("계란") {
            return "🥚"
        } else if name.contains("오이") {
            return "🥒"
        } else if name.contains("양파") {
            return "🧅"
        } else if name.contains("당근") {
            return "🥕"
        } else if name.contains("마늘") {
            return "🧄"
        } else if name.contains("우유") {
            return "🥛"
        } else if name.contains("고기") {
            return "🥩"
        } else {
            return "🥬"
        }
    }
}
