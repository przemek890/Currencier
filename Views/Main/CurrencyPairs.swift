import SwiftUI
//----------------------------------------------------

struct CurrencyPairsView: View {
    
    @State private var selectedCurrencyPair: String? = nil
    @Binding var language: String
    @Binding var searchText: String
    
    
    let dataRows: [DataRow]
    init(language: Binding<String>, searchText: Binding<String>) {
        self._language = language
        self._searchText = searchText
        self.dataRows = loadCSVData(currencies: Global.currencypairs)
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
