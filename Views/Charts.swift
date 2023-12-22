import SwiftUI

struct CandleStick: View {
    var high: Double
    var low: Double
    var open: Double
    var close: Double
    let scale: CGFloat = 1000.0 // Skala dla wysokości świec

    var body: some View {
        VStack {
            // Górna cień świecy
            Rectangle()
                .fill(close > open ? Color.green : Color.red)
                .frame(width: 1, height: CGFloat(max(high - open, high - close)) * scale)
            // Ciało świecy
            Rectangle()
                .fill(close > open ? Color.green : Color.red)
                .frame(width: 10, height: CGFloat(abs(open - close)) * scale)
            // Dolna cień świecy
            Rectangle()
                .fill(close > open ? Color.green : Color.red)
                .frame(width: 1, height: CGFloat(max(open - low, close - low)) * scale)
        }
    }
}



struct ChartView: View {
    @Binding var showMainView: Bool
    @Binding var showExchangeView: Bool
    @Binding var showAuthorView: Bool
    @Binding var showChartView: Bool

    let dataRows: [DataRow]

    init(showMainView: Binding<Bool>, showExchangeView: Binding<Bool>, showAuthorView: Binding<Bool>, showChartView: Binding<Bool>) {
        self._showMainView = showMainView
        self._showExchangeView = showExchangeView
        self._showAuthorView = showAuthorView
        self._showChartView = showChartView

        // Wczytaj dane z plików CSV
        self.dataRows = loadCSVData(currencies: ["nokpln","usdpln","eurpln","gbppln"])
        
        print(self.dataRows)
        
    }

    var body: some View {
        NavigationView {
            Form {
                // Grupuj dane według waluty
                let groupedData = Dictionary(grouping: dataRows, by: { $0.currency })
                ForEach(groupedData.keys.sorted(), id: \.self) { currency in

                        Section(header: Text(currency)) {
                            ScrollView(.horizontal) {
                                HStack {
                                    // Dodajemy indeks do ForEach, aby uczynić każdą świecę unikalną
                                    ForEach(groupedData[currency]!.indices, id: \.self) { index in
                                        let dataRow = groupedData[currency]![index]
                                        CandleStick(high: dataRow.high, low: dataRow.low, open: dataRow.open, close: dataRow.close)
                                    }
                                }
                            }
                        }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: { createToolbar(showMainView: $showMainView, showExchangeView: $showExchangeView, showAuthorView: $showAuthorView, showChartView: $showChartView) })
        }
    }
}
