import SwiftUI
import CoreData

struct RecipeListView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Ingredient.expiryDate, ascending: true)],
        animation: .default
    )
    private var ingredients: FetchedResults<Ingredient>

    let sampleRecipes = [
        Recipe(
            title: "달걀 볶음밥",
            usedIngredients: ["달걀", "양파"],
            extraIngredients: ["밥", "간장"],
            steps: [
                "달걀을 풀고 양파를 잘게 썰어줍니다.",
                "팬에 기름을 두르고 양파를 먼저 볶습니다.",
                "밥과 달걀을 넣고 함께 볶은 뒤 간장으로 간을 맞춥니다."
            ],
            time: "15분",
            difficulty: "쉬움"
        ),
        Recipe(
            title: "양파 수프",
            usedIngredients: ["양파"],
            extraIngredients: ["버터", "물", "소금"],
            steps: [
                "양파를 얇게 썰어줍니다.",
                "냄비에 버터를 녹이고 양파를 충분히 볶습니다.",
                "물을 넣고 끓인 뒤 소금으로 간을 맞춥니다."
            ],
            time: "20분",
            difficulty: "보통"
        ),
        Recipe(
            title: "오이 샐러드",
            usedIngredients: ["오이"],
            extraIngredients: ["소금", "식초", "설탕"],
            steps: [
                "오이를 얇게 썰어줍니다.",
                "소금, 식초, 설탕을 넣고 가볍게 섞습니다.",
                "차갑게 보관한 뒤 먹기 좋게 담아냅니다."
            ],
            time: "10분",
            difficulty: "쉬움"
        )
    ]

    private var ingredientNames: String {
        ingredients
            .compactMap { $0.name }
            .joined(separator: ", ")
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    recommendationHeader

                    ForEach(sampleRecipes) { recipe in
                        NavigationLink {
                            RecipeDetailView(recipe: recipe)
                        } label: {
                            recipeCard(recipe)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .background(Color(.systemGray6))
            .navigationTitle("추천 레시피")
        }
    }

    private var recommendationHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("현재 냉장고 재료 기반 추천")
                .font(.headline)

            Text("보유 재료 \(ingredients.count)개 활용 중")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text(ingredientNames.isEmpty ? "재료 없음" : ingredientNames)
                .font(.caption)
                .foregroundColor(.green)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.green.opacity(0.12))
        .cornerRadius(18)
    }

    private func recipeCard(_ recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(recipe.title)
                .font(.title3)
                .fontWeight(.bold)

            HStack(spacing: 12) {
                Label(recipe.time, systemImage: "clock")
                Label(recipe.difficulty, systemImage: "star.fill")
            }
            .font(.subheadline)
            .foregroundColor(.gray)

            Text("사용 재료: \(recipe.usedIngredients.joined(separator: ", "))")
                .font(.caption)
                .foregroundColor(.green)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 5)
        .contentShape(Rectangle())
    }
}

struct Recipe: Identifiable {
    let id = UUID()
    let title: String
    let usedIngredients: [String]
    let extraIngredients: [String]
    let steps: [String]
    let time: String
    let difficulty: String
}
