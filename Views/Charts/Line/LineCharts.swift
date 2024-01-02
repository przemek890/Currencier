import SwiftUI
import SwiftUICharts

struct LineChartsView: View {
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