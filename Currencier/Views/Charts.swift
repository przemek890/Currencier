import SwiftUI
import SwiftUICharts

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct CandleStick: View {
    var id: Int
    var date: String
    var high: Double
    var low: Double
    var open: Double
    var close: Double
    var curr: String
    var maxHighValue: Double
    var minLowValue: Double
    @Binding var selectedCandle: Int?
    @Binding var selectedCurrency: String?
    @AppStorage("isDarkMode") private var isDarkMode = false

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
        .padding(.horizontal, 10)
        .offset(y: 15)
        if selectedCandle == id && curr == selectedCurrency {
            VStack {
                Text("Currency: \(curr) [\(date)]")
                    .font(.system(size: 12))
                    .bold()
                Text("Open: \(open)")
                    .font(.system(size: 12))
                Text("High: \(high)")
                    .font(.system(size: 12))
                Text("Low: \(low)")
                    .font(.system(size: 12))
                Text("Close: \(close)")
                    .font(.system(size: 12))
            }
            .padding(.horizontal, 10)
            .background(isDarkMode ? Color.black : Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            .foregroundColor(isDarkMode ? Color.white : Color.black)
            .offset(y: CGFloat((midValue - max(open, close)) / scale) + 8)
            .overlay(
                Triangle()
                    .fill(isDarkMode ? Color.black : Color.white)
                    .frame(width: 20, height: 20)
                    .rotationEffect(.degrees(-90))
                    .offset(x: -10,y: CGFloat((midValue - max(open, close)) / scale) + 8),
                alignment: .leading
            )
        }
    }
}


struct CandleChartsView: View {
    @Binding var searchText: String
    @Binding var language: String
    let dataRows: [DataRow]
    @Binding var selectedCandle: Int?
    @State private var selectedCurrency: String? // Dodajemy nową zmienną stanu

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
                                        CandleStick(id: index,date: dataRow.date, high: dataRow.high, low: dataRow.low, open: dataRow.open, close: dataRow.close,curr: currency, maxHighValue: maxHighValue,minLowValue: minLowValue, selectedCandle: $selectedCandle, selectedCurrency: $selectedCurrency)
                                            .onTapGesture {
                                                self.selectedCandle = index
                                                self.selectedCurrency = currency
                                            }
                                    }
                                }
                                .frame(height: 400)
                                .background(
                                    VStack {
                                        ForEach(0..<14, id: \.self) { index in
                                            Divider()
                                            Spacer()
                                        }
                                        Divider()
                                    }
                                    .alignmentGuide(.leading) { d in d[.bottom] }
                                    .onTapGesture { self.selectedCandle = nil }
                                )
                            }
                        }
                    }
                }
            }
        }
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
    @State private var selectedRange = 30
    @State private var selectedCandle: Int?
    
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
                    CandleChartsView(searchText: $searchText, language: $language, dataRows: filterDataRows(dataRows, range: selectedRange), selectedCandle: $selectedCandle) // Przekazujemy selectedCandle
                }
            }
            .onChange(of: selectedRange) { _ , _ in
                self.selectedCandle = nil
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
