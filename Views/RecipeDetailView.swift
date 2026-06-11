import SwiftUI
import CoreData

struct RecipeDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isSaved = false
    
    let recipe: Recipe
    let showFavoriteButton: Bool
    
    init(recipe: Recipe, showFavoriteButton: Bool = true) {
        self.recipe = recipe
        self.showFavoriteButton = showFavoriteButton
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                Text(recipe.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                HStack(spacing: 16) {
                    Label(recipe.time, systemImage: "clock")
                    Label(recipe.difficulty, systemImage: "star.fill")
                }
                .foregroundColor(.gray)
                
                ingredientSection(
                    title: "사용한 냉장고 재료",
                    ingredients: recipe.usedIngredients,
                    color: .green
                )
                
                ingredientSection(
                    title: "추가로 필요한 재료",
                    ingredients: recipe.extraIngredients,
                    color: .orange
                )
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("조리 순서")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                            Text("\(index + 1). \(step)")
                                .lineSpacing(6)
                        }
                    }
                }
                
                if showFavoriteButton {
                    Button {
                        saveFavoriteRecipe()
                    } label: {
                        Text(isSaved ? "저장 완료" : "즐겨찾기 저장")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isSaved ? Color.gray : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                    .disabled(isSaved)
                }
            }
            .padding()
        }
        .navigationTitle("레시피 상세")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func ingredientSection(title: String, ingredients: [String], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            
            if ingredients.isEmpty {
                Text("표시할 재료가 없어요")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(ingredients, id: \.self) { ingredient in
                            ingredientTag(ingredient, color: color)
                        }
                    }
                }
            }
        }
    }
    
    private func ingredientTag(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.subheadline)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(color.opacity(0.15))
            .cornerRadius(12)
    }
    
    private func saveFavoriteRecipe() {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", recipe.title)
        
        do {
            let existingFavorites = try viewContext.fetch(request)
            
            if !existingFavorites.isEmpty {
                isSaved = true
                return
            }
            
            let favorite = FavoriteRecipe(context: viewContext)
            favorite.id = UUID()
            favorite.title = recipe.title
            favorite.createdAt = Date()

            favorite.usedIngredientsText = recipe.usedIngredients.joined(separator: "|")
            favorite.extraIngredientsText = recipe.extraIngredients.joined(separator: "|")
            favorite.stepsText = recipe.steps.joined(separator: "|")
            favorite.time = recipe.time
            favorite.difficulty = recipe.difficulty
            
            try viewContext.save()
            isSaved = true
            
        } catch {
            print("즐겨찾기 저장 실패: \(error.localizedDescription)")
        }
    }
}
