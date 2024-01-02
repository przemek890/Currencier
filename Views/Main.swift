import SwiftUI

struct ContentView: View {
    @StateObject private var dataLoader = DataLoader()

    @State private var showMainView = true
    @State private var showChartView = false
    @State private var showExchangeView = false
    @State private var showOptionsView = false
    
    @State private var language: String = "en"
    @State private var searchText: String = ""
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    var body: some View {
        if dataLoader.isDataLoaded {
            NavigationView {
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
                            CurrencyPairsView(language: $language,searchText: $searchText)
                        }
                    }
                }
                .preferredColorScheme(isDarkMode ? .dark : .light)
                
                .fullScreenCover(isPresented: $showChartView) {
                    ChartView(showMainView: $showMainView, showExchangeView: $showExchangeView, showOptionsView: $showOptionsView, showChartView: $showChartView,language: $language)
                }
                .fullScreenCover(isPresented: $showOptionsView) {
                    OptionsView(showMainView: $showMainView, showExchangeView: $showExchangeView, showOptionsView: $showOptionsView, showChartView: $showChartView,language: $language)
                }
                .fullScreenCover(isPresented: $showExchangeView) {
                    ExchangeView(showMainView: $showMainView, showExchangeView: $showExchangeView, showOptionsView: $showOptionsView, showChartView: $showChartView,language: $language)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: { createToolbar(showMainView: $showMainView, showExchangeView: $showExchangeView,
                                                  showOptionsView: $showOptionsView, showChartView: $showChartView,language: $language) })
            }
            .navigationViewStyle(StackNavigationViewStyle())
        } 
        else {
            Text(language == "en" ? "Loading..." : "Ładowanie")
                .onAppear {
                    dataLoader.loadData()
            }
        }
    }
}

//#Preview { // Turn on iPhone view
//    ContentView()
//}


