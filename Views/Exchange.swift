import SwiftUI
import SwiftUICharts

struct ChartView: View {
    @Binding var language: String
    
    @State private var searchText = ""
    @State private var showLineChart = true
    @State private var selectedRange = 30
    @State private var selectedCandle: Int?
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    let dataRows: [DataRow]
    
    init(language: Binding<String>) {
        self._language = language
        self.dataRows = loadCSVData(currencies: Global.currencypairs)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if verticalSizeClass == .regular {
                    HStack {
                        SearchBar(text: $searchText, language: $language)
                        
                        Menu {
                            VStack {
                                Picker(selection: $showLineChart, label: Text(chartTypeLabel)) {
                                    ChartTypeOption(icon: "line.diagonal", label: lineChartLabel, tag: true)
                                    ChartTypeOption(icon: "chart.xyaxis.line", label: candleChartLabel, tag: false)
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding(.horizontal)
                                
                                Picker(selection: $selectedRange, label: Text(rangeLabel)) {
                                    RangeOption(icon: "calendar", label: weekLabel, tag: 8)
                                    RangeOption(icon: "calendar", label: monthLabel, tag: 31)
                                    RangeOption(icon: "calendar", label: yearLabel, tag: 366)
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding(.horizontal)
                            }
                            .padding()
                        } label: {
                            HStack {
                                Image(systemName: "ellipsis.circle")
                                    .imageScale(.large)
                                    .frame(width: 40, height: 40)
                                    .padding(.trailing, 20)
                            }
                        }
                    }
                }
                
                if showLineChart {
                    LineChartsView(searchText: $searchText, language: $language, dataRows: filterDataRows(dataRows, range: selectedRange))
                } else {
                    CandleChartsView(searchText: $searchText, language: $language, dataRows: filterDataRows(dataRows, range: selectedRange), selectedCandle: $selectedCandle)
                }
            }
            .onChange(of: selectedRange) { _ in
                self.selectedCandle = nil
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
    
    private var chartTypeLabel: String {
        language == "en" ? "Chart Type" : "Rodzaj Wykresu"
    }
    
    private var lineChartLabel: String {
        language == "en" ? "Line" : "Liniowy"
    }
    
    private var candleChartLabel: String {
        language == "en" ? "Candle" : "Świecowy"
    }
    
    private var rangeLabel: String {
        language == "en" ? "Range" : "Zakres"
    }
    
    private var weekLabel: String {
        language == "en" ? "Week" : "Tydzień"
    }
    
    private var monthLabel: String {
        language == "en" ? "Month" : "Miesiąc"
    }
    
    private var yearLabel: String {
        language == "en" ? "Year" : "Rok"
    }
}

struct ChartTypeOption: View {
    let icon: String
    let label: String
    let tag: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.primary)
            Text(label)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .tag(tag)
        .padding()
    }
}


struct RangeOption: View {
    let icon: String
    let label: String
    let tag: Int
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.primary)
            Text(label)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .tag(tag)
        .padding()
    }
}
