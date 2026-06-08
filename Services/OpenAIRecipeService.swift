import Foundation

struct OpenAIRecipeService {
    
    func generateRecipes(from ingredients: String) async throws -> [Recipe] {
        // TODO: OpenAI API 연결 예정
        // 지금은 테스트용 더미 데이터를 반환
        
        return [
            Recipe(
                title: "\(ingredients) 활용 추천 레시피",
                usedIngredients: ingredients
                    .split(separator: ",")
                    .map { $0.trimmingCharacters(in: .whitespaces) },
                extraIngredients: ["소금", "후추", "간장"],
                steps: [
                    "냉장고 재료를 손질합니다.",
                    "팬에 재료를 넣고 볶거나 끓입니다.",
                    "간을 맞춘 뒤 접시에 담아 완성합니다."
                ],
                time: "15분",
                difficulty: "쉬움"
            )
        ]
    }
}
