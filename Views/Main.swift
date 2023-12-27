import SwiftUI

struct CurrencyPairView: View {
    var currency1: String
    var currency2: String
    var high: Double
    var low: Double
    var open: Double
    var close: Double
    var isSelected: Bool
    @Binding var language: String
    
    var body: some View {
        HStack {
            HStack {
                Image(currency1)
                Image(currency2)
                    .offset(x: -17)
            }
            .scaleEffect(0.40)
            Spacer()
            if isSelected {
                let change = close - open
                Text("\(language == "en" ? "Change from last month: " : "Zmiana wzgledem ostatniego miesiaca: ")\(String(format: "%.2f", change * 100 / open))%")
                    .font(.system(size: 11))
                    .foregroundColor(change > 0 ? .green : .red)
            } else {
                Text("\(String(format: "%.4f", open))")
                    .font(.system(size: 14))
                Spacer()
                Text("\(String(format: "%.4f", high))")
                    .font(.system(size: 14))
                Spacer()
                Text("\(String(format: "%.4f", low))")
                    .font(.system(size: 14))
                Spacer()
                Text("\(String(format: "%.4f", close))")
                    .font(.system(size: 14))
            }
        }
        .frame(height: 50) // Zwiększ wysokość wiersza
    }
}


struct CurrencyPairsView: View {
    let currencyPairs = ["nokpln","usdpln","eurpln","gbppln",
                         "plnnok","usdnok","eurnok","gbpnok",
                         "plnusd","nokusd","eurusd","gbpusd",
                         "plngbp","nokgbp","eurgbp","usdgbp",
                         "plneur", "nokeur","gbpeur","usdeur"]
    
    @State private var selectedCurrencyPair: String? = nil
    @Binding var language: String
    @Binding var searchText: String
    
    
    let dataRows: [DataRow]
    init(language: Binding<String>, searchText: Binding<String>) {
        self._language = language
        self._searchText = searchText
        self.dataRows = loadCSVData(currencies: currencyPairs)
    }

    var body: some View {
        let groupedData = Dictionary(grouping: dataRows, by: { $0.currency })
        ForEach(groupedData.keys.sorted(), id: \.self) { currencyPair in
            let sortedData = groupedData[currencyPair]!.sorted(by: { $0.date > $1.date })
            let validData = sortedData.filter { $0.date != "Data" }
            if let firstValidRow = validData.first {
                let high = firstValidRow.high
                let low = firstValidRow.low
                let open = firstValidRow.open
                let close = firstValidRow.close
                if currencyPair.lowercased().contains(searchText.lowercased()) || searchText.isEmpty {
                    CurrencyPairView(currency1: String(currencyPair.prefix(3)), currency2: String(currencyPair.suffix(3)), high: high, low: low, open: open, close: close, isSelected: selectedCurrencyPair == currencyPair,language: $language)
                        .onTapGesture {
                            if selectedCurrencyPair == currencyPair {
                                selectedCurrencyPair = nil
                            } else {
                                selectedCurrencyPair = currencyPair
                            }
                        }
                        .opacity(selectedCurrencyPair == nil || selectedCurrencyPair == currencyPair ? 1 : 0.5)
                }
            }
        }
    }
}

class DataLoader: ObservableObject {
    @Published var isDataLoaded = false

    func loadData() {
        let currencies = ["nokpln","usdpln","eurpln","gbppln",
                          "plnnok","usdnok","eurnok","gbpnok",
                          "plnusd","nokusd","eurusd","gbpusd",
                          "plngbp","nokgbp","eurgbp","usdgbp",
                          "plneur", "nokeur","gbpeur","usdeur"]
        DispatchQueue.global(qos: .background).async {
            getData(currencies: currencies)
            DispatchQueue.main.async {
                self.isDataLoaded = true
            }
        }
    }
}

struct ContentView: View {
    @StateObject private var dataLoader = DataLoader()

    @State private var showMainView = true
    @State private var showChartView = false
    @State private var showExchangeView = false
    @State private var showAuthorView = false
    
    @State private var language: String = "en"
    @State private var searchText: String = ""

    var body: some View {
        if dataLoader.isDataLoaded {
            NavigationView {
                VStack {
                    Spacer() // Dodaj odstęp na górze
                    Text("CURRENCIER")
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
                
                .fullScreenCover(isPresented: $showChartView) {
                    ChartView(showMainView: $showMainView, showExchangeView: $showExchangeView, showAuthorView: $showAuthorView, showChartView: $showChartView,language: $language)
                }
                .fullScreenCover(isPresented: $showAuthorView) {
                    AuthorView(showMainView: $showMainView, showExchangeView: $showExchangeView, showAuthorView: $showAuthorView, showChartView: $showChartView,language: $language)
                }
                .fullScreenCover(isPresented: $showExchangeView) {
                    ExchangeView(showMainView: $showMainView, showExchangeView: $showExchangeView, showAuthorView: $showAuthorView, showChartView: $showChartView,language: $language)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: { createToolbar(showMainView: $showMainView, showExchangeView: $showExchangeView,
                                                  showAuthorView: $showAuthorView, showChartView: $showChartView,language: $language) })
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


