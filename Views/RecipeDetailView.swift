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
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("필요한 재료")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            
                            ingredientTag("🥚 달걀")
                            ingredientTag("🧅 양파")
                            ingredientTag("🍚 밥")
                            ingredientTag("🥫 간장")
                        }
                    }
                }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("조리 순서")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Text("1. 재료를 손질합니다.\n2. 팬에 재료를 볶습니다.\n3. 간을 맞춘 뒤 완성합니다.")
                            .lineSpacing(6)
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
        }
        
    }
    @ViewBuilder
    func ingredientTag(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.green.opacity(0.15))
            .cornerRadius(12)
    }

