import SwiftUI
struct MainView: View {
    @Binding var searchText: String
    @ObservedObject var languageManager = LanguageManager.shared

    var body: some View {
        VStack {
            Spacer()
            Text(localizedText("CURRENCIER"))
                .font(.largeTitle)
                .padding()
                .bold()
                .opacity(0.5)
            SearchBar(text: $searchText)
            Form {
                Section(header:
                            HStack {
                    Text(localizedText("Currency pairs"))
                    Spacer()
                    Text(localizedText("Open"))
                    Spacer()
                    Text(localizedText("High"))
                    Spacer()
                    Text(localizedText("Low"))
                    Spacer()
                    Text(localizedText("Close"))
                }
                ) {
                    CurrencyPairsView(searchText: $searchText)
                }
            }
        }
    }
}
