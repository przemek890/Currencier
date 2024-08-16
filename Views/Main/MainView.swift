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
                    Text(language == "en" ? "Currency pairs" : "Pary walutowe")
                    Spacer()
                    Text(language == "en" ? "Open" : "Otwarcie")
                    Spacer()
                    Text(language == "en" ? "High" : "Najwyższy" )
                    Spacer()
                    Text(language == "en" ? "Low" : "Najniższy")
                    Spacer()
                    Text(language == "en" ? "Close" : "Zamknięcie")
                }
                ) {
                    CurrencyPairsView(language: $language, searchText: $searchText)
                }
            }
        }
    }
}
