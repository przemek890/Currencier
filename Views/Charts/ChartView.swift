import SwiftUI
import SwiftUICharts

struct ChartView: View {
    @State private var searchText = ""
    @State private var showLineChart = true
    @State private var selectedRange = 30
    @State private var selectedCandle: Int?
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @ObservedObject var languageManager = LanguageManager.shared
    
    let dataRows: [DataRow]
    
    init() {
        self.dataRows = loadCSVData(currencies: Global.currencypairs)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if verticalSizeClass == .regular {
                    HStack {
                        SearchBar(text: $searchText)
                        
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
                    LineChartsView(searchText: $searchText, dataRows: filterDataRows(dataRows, range: selectedRange))
                } else {
                    CandleChartsView(searchText: $searchText, dataRows: filterDataRows(dataRows, range: selectedRange), selectedCandle: $selectedCandle)
                }
            }
            .onChange(of: selectedRange) {
                self.selectedCandle = nil
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
    
    private var chartTypeLabel: String {
        localizedText("Chart Type")
    }
    
    private var lineChartLabel: String {
        localizedText("Line")
    }
    
    private var candleChartLabel: String {
        localizedText("Candle")
    }
    
    private var rangeLabel: String {
        localizedText("Range")
    }
    
    private var weekLabel: String {
        localizedText("Week")
    }
    
    private var monthLabel: String {
        localizedText("Month")
    }
    
    private var yearLabel: String {
        localizedText("Year")
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
