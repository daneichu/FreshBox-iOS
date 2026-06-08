import Foundation

struct OpenAIRecipeService {

    func generateRecipes(from ingredients: String) async throws -> [Recipe] {

        let apiKey = ConfigManager.openAIKey

        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            return fallbackRecipes(from: ingredients)
        }

        let prompt = """
        냉장고 재료: \(ingredients)

        위 재료를 활용한 간단한 레시피 1개를 추천해주세요.
        아래 JSON 형식으로만 응답해주세요.

        {
          "title": "",
          "usedIngredients": [],
          "extraIngredients": [],
          "steps": [],
          "time": "",
          "difficulty": ""
        }

        반드시 JSON 객체만 반환하고, 설명 문장이나 코드블록은 쓰지 마세요.
        """

        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "response_format": [
                "type": "json_object"
            ],
            "temperature": 0.7
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body)

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                return fallbackRecipes(from: ingredients)
            }

            let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)

            guard let content = openAIResponse.choices.first?.message.content,
                  let recipeData = content.data(using: .utf8) else {
                return fallbackRecipes(from: ingredients)
            }

            let decodedRecipe = try JSONDecoder().decode(RecipeDTO.self, from: recipeData)

            return [
                Recipe(
                    title: decodedRecipe.title,
                    usedIngredients: decodedRecipe.usedIngredients,
                    extraIngredients: decodedRecipe.extraIngredients,
                    steps: decodedRecipe.steps,
                    time: decodedRecipe.time,
                    difficulty: decodedRecipe.difficulty
                )
            ]

        } catch {
            return fallbackRecipes(from: ingredients)
        }
    }

    private func fallbackRecipes(from ingredients: String) -> [Recipe] {
        let usedIngredients = ingredients
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }

        return [
            Recipe(
                title: "\(usedIngredients.first ?? "냉장고 재료") 활용 간단 레시피",
                usedIngredients: usedIngredients,
                extraIngredients: ["소금", "후추", "간장"],
                steps: [
                    "냉장고 재료를 먹기 좋은 크기로 손질합니다.",
                    "팬이나 냄비에 재료를 넣고 익혀줍니다.",
                    "소금, 후추, 간장으로 간을 맞춥니다.",
                    "그릇에 담아 완성합니다."
                ],
                time: "15분",
                difficulty: "쉬움"
            )
        ]
    }
}

struct OpenAIResponse: Codable {
    let choices: [OpenAIChoice]
}

struct OpenAIChoice: Codable {
    let message: OpenAIMessage
}

struct OpenAIMessage: Codable {
    let content: String
}

struct RecipeDTO: Codable {
    let title: String
    let usedIngredients: [String]
    let extraIngredients: [String]
    let steps: [String]
    let time: String
    let difficulty: String
}
