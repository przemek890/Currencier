import SwiftUI
//----------------------------------------------------

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
                            ZStack {
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
                                }
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
                            .onTapGesture { self.selectedCandle = nil }
                        }
                    }
                }
            }
        }
    }
}
