import SwiftUI
struct MainView: View {
    @Binding var searchText: String
    @Binding var language: String

    var body: some View {
        VStack {
            Spacer() // Dodaj odstęp na górze
            Text(language == "en" ? "CURRENCIER" : "WALUTOR")
                .font(.largeTitle) // Zwiększ rozmiar czcionki
                .padding()
                .bold()
                .opacity(0.5)
            SearchBar(text: $searchText, language: $language)
            Form {
                Section(header:
                            HStack {
                    Text(language == "en" ? "Currency pairs" : "Pary walutowe ")
                    Spacer()
                    Text(language == "en" ? "Open" : "Otw.")
                    Spacer()
                    Text(language == "en" ? "High" : "Najw." )
                    Spacer()
                    Text(language == "en" ? "Low" : "Najn.")
                    Spacer()
                    Text(language == "en" ? "Close" : "Zamk.")
                }
                ) {
                    CurrencyPairsView(language: $language, searchText: $searchText)
                }
            }
        }
    }
}
