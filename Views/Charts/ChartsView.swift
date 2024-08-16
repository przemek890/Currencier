import SwiftUI
import SwiftUICharts
//----------------------------------------------------

struct ChartView: View {
    @Binding var language: String
    
    @State private var searchText = ""
    @State private var showLineChart = true
    @State private var selectedRange = 30
    @State private var selectedCandle: Int?
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    
    let dataRows: [DataRow]
    
    init(language:Binding<String>) {
        self._language = language
        
        self.dataRows = loadCSVData(currencies: Global.currencypairs)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if verticalSizeClass == .regular {
                    SearchBar(text: $searchText,language: $language)
                    Picker(language == "en" ? "Chart" : "Wykres", selection: $showLineChart) {
                        Text(language == "en" ? "Line" : "Liniowy").tag(true)
                        Text(language == "en" ? "Candle" : "Świecowy").tag(false)
                    }
                    .frame(height: 15)
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    Picker(language == "en" ? "Range" : "Zakres", selection: $selectedRange) {
                        Text(language == "en" ? "Week" : "Tydzień").tag(8)
                        Text(language == "en" ? "Month" : "Miesiąc").tag(31)
                        Text(language == "en" ? "Year" : "Rok").tag(366)
                    }
                    .frame(height: 15)
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
                if showLineChart {
                    LineChartsView(searchText: $searchText,language: $language, dataRows: filterDataRows(dataRows, range: selectedRange))
                } else {
                    CandleChartsView(searchText: $searchText, language: $language, dataRows: filterDataRows(dataRows, range: selectedRange), selectedCandle: $selectedCandle)
                }
            }
            .onChange(of: selectedRange) { _ , _ in
                self.selectedCandle = nil
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
