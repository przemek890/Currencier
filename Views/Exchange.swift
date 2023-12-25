import SwiftUI

struct ExchangeView: View {
    @State private var itemSelected1 = 0
    @State private var itemSelected2 = 1
    @State private var amount : String = ""
    @State private var transactionType = "Buy"
    
    @Binding var showMainView: Bool
    @Binding var showExchangeView: Bool
    @Binding var showAuthorView: Bool
    @Binding var showChartView: Bool
    
    @Binding var language: String
    
    private let converter = CurrencyConverter()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(language == "en" ? "Convert a currency" : "Przelicz walutę")) {
                    
                    Picker(selection: $itemSelected2, label: Text(language == "en" ? "Base" : "Bazowa")) {
                        ForEach(Array(converter.currencies.enumerated()), id: \.offset) { index, currency in
                            Text(currency).tag(index)
                        }
                    }
                    
                    Picker(selection: $itemSelected1, label: Text(language == "en" ? "Quoted" : "Kwotowana")) {
                        ForEach(Array(converter.currencies.enumerated()), id: \.offset) { index, currency in
                            Text(currency).tag(index)
                        }
                    }
                    
                }
                
                Section(header: Text(language == "en" ? "Amount" : "Ilość")) {
                    TextField(language == "en" ? "Enter an amount" : "Wprowadź ilość" ,text: $amount)
                        .keyboardType(.decimalPad)
                }

                
                Section(header: Text(language == "en" ? "Conversion" : "Konwersja")) {
                    Text("\(converter.convert(amount: Double(amount) ?? 0.0, from: itemSelected1, to: itemSelected2)) \(converter.currencies[itemSelected1])")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: { createToolbar(showMainView: $showMainView, showExchangeView: $showExchangeView, showAuthorView: $showAuthorView, showChartView: $showChartView,language: $language) })
        }
    }
}

