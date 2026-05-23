import SwiftUI

struct RecipeListView: View {

    let sampleRecipes = [
        Recipe(title: "달걀 볶음밥", time: "15분", difficulty: "쉬움"),
        Recipe(title: "양파 수프", time: "20분", difficulty: "보통"),
        Recipe(title: "오이 샐러드", time: "10분", difficulty: "쉬움")
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {

                    ForEach(sampleRecipes) { recipe in
                        NavigationLink {
                            RecipeDetailView(recipe: recipe)
                        } label: {

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
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.05), radius: 5)
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
}

struct Recipe: Identifiable {
    let id = UUID()
    let title: String
    let time: String
    let difficulty: String
}
