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
    
    private let converter = CurrencyConverter()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Convert a currency")) {
                    TextField("Enter an amount",text: $amount)
                        .keyboardType(.decimalPad)
                    
                    Picker(selection: $itemSelected1, label: Text("From")) {
                        ForEach(Array(converter.currencies.enumerated()), id: \.offset) { index, currency in
                            Text(currency).tag(index)
                        }
                    }
                    
                    Picker(selection: $itemSelected2, label: Text("To")) {
                        ForEach(Array(converter.currencies.enumerated()), id: \.offset) { index, currency in
                            Text(currency).tag(index)
                        }
                    }
                }
                
                Section(header: Text("Conversion")) {
                    Text("\(converter.convert(amount: Double(amount) ?? 0.0, from: itemSelected1, to: itemSelected2)) \(converter.currencies[itemSelected2])")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: { createToolbar(showMainView: $showMainView, showExchangeView: $showExchangeView, showAuthorView: $showAuthorView, showChartView: $showChartView) })
        }
    }
}

