import SwiftUI
import CoreData

struct RecipeListView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Ingredient.expiryDate, ascending: true)],
        animation: .default
    )
    private var ingredients: FetchedResults<Ingredient>

    @State private var recipes: [Recipe] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    private let recipeService = OpenAIRecipeService()

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

                    Button {
                        Task {
                            await generateRecipes()
                        }
                    } label: {
                        Text(isLoading ? "추천 생성 중..." : "레시피 추천받기")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(ingredientNames.isEmpty ? Color.gray : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                    .disabled(ingredientNames.isEmpty || isLoading)

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                    }

                    if isLoading {
                        ProgressView("레시피를 찾는 중...")
                            .frame(maxWidth: .infinity)
                            .padding(.top, 30)
                    }

                    if recipes.isEmpty && !isLoading {
                        VStack(spacing: 12) {
                            Image(systemName: "fork.knife.circle")
                                .font(.system(size: 54))
                                .foregroundColor(.gray)

                            Text("아직 추천된 레시피가 없어요")
                                .font(.headline)

                            Text("냉장고 재료를 추가한 뒤 추천을 받아보세요.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                    } else {
                        ForEach(recipes) { recipe in
                            NavigationLink {
                                RecipeDetailView(recipe: recipe)
                            } label: {
                                recipeCard(recipe)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
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

    private func generateRecipes() async {
        guard !ingredientNames.isEmpty else {
            errorMessage = "냉장고 재료를 먼저 추가해주세요."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            recipes = try await recipeService.generateRecipes(from: ingredientNames)
        } catch {
            errorMessage = "레시피 추천을 불러오지 못했어요."
            print("레시피 생성 실패: \(error.localizedDescription)")
        }

        isLoading = false
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
