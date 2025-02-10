import SwiftUI
//----------------------------------------------------

struct OptionsView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("isWhiteBlack") private var isWhiteBlack = false
    @ObservedObject var languageManager = LanguageManager.shared
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(localizedText("Theme"))) {
                    VStack(alignment: .leading) {
                        HStack {
                            Image("lighting")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                            Spacer().frame(width: 20)
                            Toggle(isOn: $isDarkMode) {
                                Text(isDarkMode ? (localizedText("Dark mode")) : (localizedText("Light mode")))
                            }
                        }
                        HStack {
                            Image(isWhiteBlack ? "white-black" : "green-red")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 35)
                            Spacer().frame(width: 17)
                            Toggle(isOn: $isWhiteBlack) {
                                Text(isWhiteBlack ? (localizedText("White-black mode")) : (localizedText("Green-red mode")))
                            }
                        }
                    }
                }
                Section(header: Text(localizedText("Language"))) {
                    Button(action: {
                        LanguageManager.shared.language = LanguageManager.shared.language == "en" ? "pl" : "en"
                    }) {
                        HStack {
                            Image(LanguageManager.shared.language == "en" ? "usd" : "pln")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                            Spacer().frame(width: 20)
                            Text(localizedText("English"))
                        }
                    }
                }
                Section(header: Text(localizedText("Author"))) {
                    VStack {
                        HStack{
                            Image("github")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                            Spacer().frame(width: 20)
                            Link("Przemysław Janiszewski", destination: URL(string: "https://github.com/przemek890")!)
                        }
                    }
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
