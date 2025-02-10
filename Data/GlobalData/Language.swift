import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
@Published var language: String {
        didSet {
            UserDefaults.standard.set(language, forKey: "appLanguage")
            loadDictionary(for: language)
        }
    }
@Published var translations: [String: String] = [:]
private init() {
        self.language = UserDefaults.standard.string(forKey: "appLanguage") ?? "en"
        loadDictionary(for: language)
    }
private func loadDictionary(for language: String) {
        guard let url = Bundle.main.url(forResource: language, withExtension: "json") else {
            print("Could not find \(language).json")
            translations = [:]
            return
        }
        do {
            let data = try Data(contentsOf: url)
            translations = try JSONDecoder().decode([String: String].self, from: data)
        } catch {
            print("Error loading dictionary for \(language): \(error)")
            translations = [:]
        }
    }
func localizedText(for key: String) -> String {
        return translations[key] ?? key
    }
}
func localizedText(_ key: String) -> String {
    return LanguageManager.shared.localizedText(for: key)
}
