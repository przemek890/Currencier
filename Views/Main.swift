import SwiftUI

struct CurrencyPairView: View {
    var currency1: String
    var currency2: String
    var high: Double
    var low: Double
    var open: Double
    var close: Double
    
    var body: some View {
        HStack {
            HStack {
                Image(currency1)
                Image(currency2)
                    .offset(x: -17)
            }
            .scaleEffect(0.33)
            Spacer()
            Text("\(String(format: "%.4f", open))")
                .font(.system(size: 11))
            Spacer()
            Text("\(String(format: "%.4f", high))")
                .font(.system(size: 11))
            Spacer()
            Text("\(String(format: "%.4f", low))")
                .font(.system(size: 11))
            Spacer()
            Text("\(String(format: "%.4f", close))")
                .font(.system(size: 11))
        }
    }
}
struct CurrencyPairsView: View {
    let currencyPairs = ["nokpln","usdpln","eurpln","gbppln",
                         "plnnok","usdnok","eurnok","gbpnok",
                         "plnusd","nokusd","eurusd","gbpusd",
                         "plngbp","nokgbp","eurgbp","usdgbp"]
    
    var dataRows: [DataRow] {
        loadCSVData(currencies: currencyPairs)
    }
    
    var body: some View {
        // Grupuj dane według pary walutowej
        let groupedData = Dictionary(grouping: dataRows, by: { $0.currency })
        ForEach(groupedData.keys.sorted(), id: \.self) { currencyPair in
            
            // Posortuj dane dla bieżącej pary walutowej według daty
            let sortedData = groupedData[currencyPair]!.sorted(by: { $0.date > $1.date })
            
            // Pomiń wiersze z niepoprawnymi danymi
            let validData = sortedData.filter { $0.date != "Data" }
            
            // Jeśli są jakiekolwiek poprawne dane, wybierz high, low, open i close dla najświeższej daty
            if let firstValidRow = validData.first {
                let high = firstValidRow.high
                let low = firstValidRow.low
                let open = firstValidRow.open
                let close = firstValidRow.close
                
                // Przekazanie high, low, open i close do CurrencyPairView
                CurrencyPairView(currency1: String(currencyPair.prefix(3)), currency2: String(currencyPair.suffix(3)), high: high, low: low, open: open, close: close)
            }
        }
    }
}



struct ContentView: View {
    @State private var showMainView = true
    @State private var showChartView = false
    @State private var showExchangeView = false
    @State private var showAuthorView = false
    
    @State private var isDataLoaded = false

    var body: some View {
        if isDataLoaded {
            NavigationView {
                Form {
                    Section(header:
                        HStack {
                            Text("Currency pairs")
                            Spacer()
                            Text("Open")
                            Spacer()
                            Text("High")
                            Spacer()
                            Text("Low")
                            Spacer()
                            Text("Close")
                        }
                    ) {
                        CurrencyPairsView()
                    }
                }
                .fullScreenCover(isPresented: $showChartView) {
                    ChartView(showMainView: $showMainView, showExchangeView: $showExchangeView, showAuthorView: $showAuthorView, showChartView: $showChartView)
                }
                .fullScreenCover(isPresented: $showAuthorView) {
                    AuthorView(showMainView: $showMainView, showExchangeView: $showExchangeView, showAuthorView: $showAuthorView, showChartView: $showChartView)
                }
                .fullScreenCover(isPresented: $showExchangeView) {
                    ExchangeView(showMainView: $showMainView, showExchangeView: $showExchangeView, showAuthorView: $showAuthorView, showChartView: $showChartView)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: { createToolbar(showMainView: $showMainView, showExchangeView: $showExchangeView, showAuthorView: $showAuthorView, showChartView: $showChartView) })
            }
        } else {
            Text("Loading...")
                .onAppear {
                    let currencies = ["nokpln","usdpln","eurpln","gbppln",
                                      "plnnok","usdnok","eurnok","gbpnok",
                                      "plnusd","nokusd","eurusd","gbpusd",
                                      "plngbp","nokgbp","eurgbp","usdgbp"]
                    DispatchQueue.global(qos: .background).async {
                        getData(currencies: currencies)
                        DispatchQueue.main.async {
                            isDataLoaded = true
                        }
                    }
                }
        }
    }
}

#Preview { // Turn on iPhone view
    ContentView()
}
