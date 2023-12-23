import SwiftUI

struct CandleStick: View {
    var high: Double
    var low: Double
    var open: Double
    var close: Double
    var curr: String
    var scale: CGFloat

    
    var body: some View {
        VStack {
            // Górna cień świecy
            Rectangle()
                .fill(close > open ? Color.green : Color.red)
                .frame(width: 1, height: CGFloat(max(high - open, high - close)) * (250 / scale))
            // Ciało świecy
            Rectangle()
                .fill(close > open ? Color.green : Color.red)
                .frame(width: 10, height: CGFloat(abs(open - close)) *  (250 / scale))
            // Dolna cień świecy
            Rectangle()
                .fill(close > open ? Color.green : Color.red)
                .frame(width: 1, height: CGFloat(max(open - low, close - low)) *  (250 / scale))
        }
    }
}

struct ScaleView: View {
    var minLowValue: Double
    var maxHighValue: Double

    var body: some View {
        VStack {
            Text("\(maxHighValue)")
            Spacer()
            Text("\(minLowValue)")
        }
    }
}
struct ScaleBarView: View {
    var minLowValue: Double
    var maxHighValue: Double

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                ForEach(0..<6, id: \.self) { index in
                    let value = (maxHighValue - minLowValue) / 5 * Double(5 - index) + minLowValue
                    Text(String(format: "%.4f", value))
                    if index < 5 {
                        Divider()
                    }
                }
            }
            Rectangle()
                .frame(width: 1)
                .foregroundColor(.gray)
        }
    }
}


struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Wyszukaj...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
        }
        .navigationBarTitle(Text("Wyszukaj"), displayMode: .inline)
    }
}




struct ChartView: View {
    @Binding var showMainView: Bool
    @Binding var showExchangeView: Bool
    @Binding var showAuthorView: Bool
    @Binding var showChartView: Bool
    @State private var searchText = ""
    
    let dataRows: [DataRow]
    
    init(showMainView: Binding<Bool>, showExchangeView: Binding<Bool>, showAuthorView: Binding<Bool>, showChartView: Binding<Bool>) {
        self._showMainView = showMainView
        self._showExchangeView = showExchangeView
        self._showAuthorView = showAuthorView
        self._showChartView = showChartView
        
        // Wczytaj dane z plików CSV
        self.dataRows = loadCSVData(currencies: ["nokpln","usdpln","eurpln","gbppln",
                                                 "plnnok","usdnok","eurnok","gbpnok",
                                                 "plnusd","nokusd","eurusd","gbpusd",
                                                 "plngbp","nokgbp","eurgbp","usdgbp"])
        print(self.dataRows)
        
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                Form {
                    // Grupuj dane według waluty
                    let groupedData = Dictionary(grouping: dataRows, by: { $0.currency })
                    ForEach(groupedData.keys.sorted(), id: \.self) { currency in
                        if currency.lowercased().contains(searchText.lowercased()) || searchText.isEmpty {
                            Section(header: Text(currency)) {
                                ScrollView(.horizontal) {
                                    HStack {
                                        // Oblicz minLowValue i maxHighValue dla bieżącej pary walutowej
                                        let minLowValue = groupedData[currency]!.compactMap({ $0.low != 0 ? $0.low : nil }).min() ?? 0
                                        let maxHighValue = groupedData[currency]!.map({ $0.high }).max() ?? 0
                                        let scale = maxHighValue - minLowValue
                                        ScaleBarView(minLowValue: minLowValue, maxHighValue: maxHighValue)
                                        ForEach(groupedData[currency]!.indices, id: \.self) { index in
                                            let dataRow = groupedData[currency]![index]
                                            CandleStick(high: dataRow.high, low: dataRow.low, open: dataRow.open, close: dataRow.close, curr: currency, scale: scale) // Przekazanie różnicy
                                        }
                                    }
                                    .frame(height: 250) // Ustawienie stałej wysokości dla HStack
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
