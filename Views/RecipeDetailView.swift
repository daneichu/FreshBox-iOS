import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
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
                
                Button {
                    print("즐겨찾기 저장")
                } label: {
                    Text("즐겨찾기 저장")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(16)
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
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(ingredients, id: \.self) { ingredient in
                        ingredientTag(ingredient, color: color)
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
}
