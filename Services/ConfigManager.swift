import Foundation

struct ConfigManager {

    static var openAIKey: String {
        guard
            let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
            let plist = NSDictionary(contentsOfFile: path),
            let key = plist["OPENAI_API_KEY"] as? String
        else {
            fatalError("OPENAI_API_KEY not found")
        }

        return key
    }
}
