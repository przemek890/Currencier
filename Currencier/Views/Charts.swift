import SwiftUI
import SwiftUICharts

struct CandleStick: View {
    var high: Double
    var low: Double
    var open: Double
    var close: Double
    var curr: String
    var maxHighValue: Double
    var minLowValue: Double
    @State private var isTapped: Bool = false

    var body: some View {
        let scale = (maxHighValue - minLowValue) / 340
        let midValue = (maxHighValue + minLowValue) / 2
        VStack {
            // Górna cień świecy
            Rectangle()
                .fill(close > open ? Color.green : Color.red)
                .frame(width: 1, height: CGFloat((high - max(open, close)) / scale))
                .offset(y: CGFloat((midValue - max(open, close)) / scale) + 8)

            // Ciało świecy
            Rectangle()
                .fill(close > open ? Color.green : Color.red)
                .frame(width: 10, height: max(CGFloat(abs(open - close)), scale/2) / scale)
                .offset(y: CGFloat((midValue - max(open, close)) / scale))
            // Dolna cień świecy
            Rectangle()
                .fill(close > open ? Color.green : Color.red)
                .frame(width: 1, height: CGFloat((min(open, close) - low) / scale))
                .offset(y: CGFloat((midValue - max(open, close)) / scale) - 8)
        }
        .padding(.horizontal, 7)
        .offset(y: 15)
    }
}



struct ScaleBarView: View {
    var minLowValue: Double
    var maxHighValue: Double

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0..<7, id: \.self) { index in
                let value = (maxHighValue - minLowValue) / 6 * Double(6 - index) + minLowValue
                HStack {
                    Text(String(format: "%.4f", value))
                        .font(.system(size: 10))
                        .alignmentGuide(.leading) { d in d[.bottom] }
                    Spacer()
                    Divider()
                        .frame(height: 50)
                }
            }
        }
        .frame(width: 50) // Ogranicz szerokość ScaleBarView
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
                        HStack {
                            // Oblicz minLowValue i maxHighValue dla bieżącej pary walutowej
                            let minLowValue = groupedData[currency]!.compactMap({ $0.low != 0 ? $0.low : nil }).min() ?? 0
                            let maxHighValue = groupedData[currency]!.map({ $0.high }).max() ?? 0
                            ScaleBarView(minLowValue: minLowValue, maxHighValue: maxHighValue)
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(groupedData[currency]!.indices, id: \.self) { index in
                                        let dataRow = groupedData[currency]![index]
                                        CandleStick(high: dataRow.high, low: dataRow.low, open: dataRow.open, close: dataRow.close,
                                                    curr: currency, maxHighValue: maxHighValue,minLowValue: minLowValue)
                                    }
                                }
                                .frame(height: 400) // Ustawienie stałej wysokości dla HStack
                                .background(
                                    VStack {
                                        ForEach(0..<14, id: \.self) { index in
                                            Divider()
                                            Spacer()
                                        }
                                        Divider()
                                    }
                                    .alignmentGuide(.leading) { d in d[.bottom] }

                                )
                            }
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
    @State private var showLineChart = true
    @State private var selectedRange = 30 // Dodaj tę zmienną
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    let dataRows: [DataRow]
    
    init(showMainView: Binding<Bool>, showExchangeView: Binding<Bool>, showAuthorView: Binding<Bool>, showChartView: Binding<Bool>,language:Binding<String>) {
        self._showMainView = showMainView
        self._showExchangeView = showExchangeView
        self._showAuthorView = showAuthorView
        self._showChartView = showChartView
        self._language = language
        
        self.dataRows = loadCSVData(currencies: ["nokpln","usdpln","eurpln","gbppln",
                                                 "plnnok","usdnok","eurnok","gbpnok",
                                                 "plnusd","nokusd","eurusd","gbpusd",
                                                 "plngbp","nokgbp","eurgbp","usdgbp",
                                                 "plneur", "nokeur","gbpeur","usdeur"])
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText,language: $language)
                Picker(language == "en" ? "Chart" : "Wykres", selection: $showLineChart) {
                    Text(language == "en" ? "Line" : "Liniowy").tag(true)
                    Text(language == "en" ? "Candle" : "Świecowy").tag(false)
                }
                .frame(height: 20)
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                Picker(language == "en" ? "Range" : "Zakres", selection: $selectedRange) {
                    Text(language == "en" ? "Month" : "Miesiąc").tag(30)
                    Text(language == "en" ? "Half Year" : "Pół roku").tag(182)
                    Text(language == "en" ? "Year" : "Rok").tag(365)
                }
                .frame(height: 20)
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                if showLineChart {
                    LineChartView(searchText: $searchText,language: $language, dataRows: filterDataRows(dataRows, range: selectedRange))
                } else {
                    CandleChartsView(searchText: $searchText, language: $language, dataRows: filterDataRows(dataRows, range: selectedRange))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: { createToolbar(showMainView: $showMainView, showExchangeView: $showExchangeView, showAuthorView: $showAuthorView, showChartView: $showChartView,language: $language) })
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    
}
func filterDataRows(_ dataRows: [DataRow], range: Int) -> [DataRow] {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let calendar = Calendar.current
    let startDate = calendar.date(byAdding: .day, value: -range, to: Date())!
    
    return dataRows.filter { dataRow in
        if let date = dateFormatter.date(from: dataRow.date) {
            return date >= startDate
        } else {
            return false
        }
    }
}
