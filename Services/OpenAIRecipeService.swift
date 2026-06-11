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

        let names = usedIngredients.joined(separator: " ")

        var recipes: [Recipe] = []

        if names.contains("돼지고기") || names.contains("고기") {

            recipes.append(
                Recipe(
                    title: "돼지고기 양파볶음",
                    usedIngredients: usedIngredients.filter {
                        $0.contains("돼지고기") || $0.contains("고기") || $0.contains("양파")
                    },
                    extraIngredients: ["간장", "마늘", "후추"],
                    steps: [
                        "돼지고기와 양파를 준비합니다.",
                        "팬에 고기를 먼저 볶습니다.",
                        "양파와 양념을 넣고 마저 볶습니다."
                    ],
                    time: "20분",
                    difficulty: "보통"
                )
            )
        }

        if names.contains("오이") {

            recipes.append(
                Recipe(
                    title: "오이무침",
                    usedIngredients: usedIngredients.filter {
                        $0.contains("오이")
                    },
                    extraIngredients: ["고춧가루", "식초", "설탕"],
                    steps: [
                        "오이를 얇게 썹니다.",
                        "양념과 함께 버무립니다.",
                        "차갑게 담아 완성합니다."
                    ],
                    time: "10분",
                    difficulty: "쉬움"
                )
            )
        }

        if names.contains("달걀") || names.contains("계란") {

            recipes.append(
                Recipe(
                    title: "달걀 양파 볶음밥",
                    usedIngredients: usedIngredients.filter {
                        $0.contains("달걀") || $0.contains("계란") || $0.contains("양파")
                    },
                    extraIngredients: ["밥", "간장", "식용유"],
                    steps: [
                        "달걀과 양파를 준비합니다.",
                        "양파와 밥을 볶습니다.",
                        "달걀과 간장을 넣어 마무리합니다."
                    ],
                    time: "15분",
                    difficulty: "쉬움"
                )
            )
        }

        if recipes.isEmpty {

            recipes.append(
                Recipe(
                    title: "냉장고 재료 간단 볶음",
                    usedIngredients: Array(usedIngredients.prefix(2)),
                    extraIngredients: ["소금", "후추"],
                    steps: [
                        "재료를 손질합니다.",
                        "팬에 볶습니다.",
                        "간을 맞춰 완성합니다."
                    ],
                    time: "15분",
                    difficulty: "쉬움"
                )
            )
        }

        return recipes
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
}
