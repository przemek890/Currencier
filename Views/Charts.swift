import SwiftUI
import SwiftUICharts

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
        .padding(.horizontal, 7)
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
        VStack(alignment: .leading) {
            ForEach(0..<6, id: \.self) { index in
                let value = (maxHighValue - minLowValue) / 5 * Double(5 - index) + minLowValue
                HStack {
                    Text(String(format: "%.4f", value))
                        .font(.system(size: 11))
                    Spacer()
                    Divider()
                }
            }
        }
    }
}

struct CandleChartsView: View {
    @Binding var searchText: String
    @Binding var language: String
    let dataRows: [DataRow]

    var body: some View {
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
                                    CandleStick(high: dataRow.high, low: dataRow.low, open: dataRow.open, close: dataRow.close, curr: currency, scale: scale)
                                }
                            }
                            .frame(height: 250) // Ustawienie stałej wysokości dla HStack
                        }
                    }
                }
            }
        }
    }
}



struct LineChartView: View {
    @Binding var searchText: String
    @Binding var language: String
    
    let dataRows: [DataRow]

    init(searchText: Binding<String>, language: Binding<String>, dataRows: [DataRow]) {
        self._searchText = searchText
        self._language = language
        self.dataRows = dataRows
    }
    
    var body: some View {
        VStack {
            // Grupuj dane według waluty
            let groupedData = Dictionary(grouping: dataRows, by: { $0.currency })
            
            ScrollView {
                VStack {
                    ForEach(groupedData.keys.sorted(), id: \.self) { currency in
                        // Filtruj dane, które mają wartość 0
                        let filteredData = groupedData[currency]!.filter { $0.open != 0 && $0.close != 0 }
                        
                        let data = filteredData.map { dataRow -> Double in
                            let average = (dataRow.open + dataRow.close) / 2
                            return average
                        }
                        if currency.lowercased().contains(searchText.lowercased()) || searchText.isEmpty {
                            LineView(data: data, title: currency, legend: currency, valueSpecifier: "%.4f")
                                .padding()
                                .frame(height: 400)
                        }
                    }
                }
            }
        }
    }
}




struct ChartView: View {
    @Binding var showMainView: Bool
    @Binding var showExchangeView: Bool
    @Binding var showAuthorView: Bool
    @Binding var showChartView: Bool
    @Binding var language: String
    
    @State private var searchText = ""
    @State private var showLineChart = true // Dodaj tę zmienną
    
    let dataRows: [DataRow]
    
    init(showMainView: Binding<Bool>, showExchangeView: Binding<Bool>, showAuthorView: Binding<Bool>, showChartView: Binding<Bool>,language:Binding<String>) {
        self._showMainView = showMainView
        self._showExchangeView = showExchangeView
        self._showAuthorView = showAuthorView
        self._showChartView = showChartView
        self._language = language
        
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
                SearchBar(text: $searchText,language: $language)
                Picker(language == "en" ? "Chart" : "Wykres", selection: $showLineChart) {
                    Text(language == "en" ? "Line" : "Liniowy").tag(true)
                    Text(language == "en" ? "Candle" : "Świecowy").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                if showLineChart {
                    LineChartView(searchText: $searchText,language: $language, dataRows: dataRows)
                } else {
                    CandleChartsView(searchText: $searchText, language: $language, dataRows: dataRows)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: { createToolbar(showMainView: $showMainView, showExchangeView: $showExchangeView, showAuthorView: $showAuthorView, showChartView: $showChartView,language: $language) })
        }
    }
}
