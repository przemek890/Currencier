import SwiftUI

struct ExchangeView: View {
    @State private var itemSelected1 = 1
    @State private var itemSelected2 = 0
    @State private var amount: String = ""
    @State private var transactionType = "Buy"
    @State private var conversionResult: String = "0.00"
    
    @Binding var language: String
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    private let converter = CurrencyConverter()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text(language == "en" ? "Convert a currency" : "Przelicz walutę")) {
                        Picker(selection: $itemSelected1, label: Text(language == "en" ? "Base" : "Bazowa")) {
                            ForEach(Array(converter.currencies.enumerated()), id: \.offset) { index, currency in
                                Text(currency).tag(index)
                            }
                        }
                        
                        Picker(selection: $itemSelected2, label: Text(language == "en" ? "Quoted" : "Kwotowana")) {
                            ForEach(Array(converter.currencies.enumerated()), id: \.offset) { index, currency in
                                Text(currency).tag(index)
                            }
                        }
                    }
                    
                    Section(header: Text(language == "en" ? "Amount" : "Ilość")) {
                        TextField(language == "en" ? "Enter an amount" : "Wprowadź ilość", text: $amount)
                            .onChange(of: amount) {
                                if amount.contains(",") {
                                    amount = amount.replacingOccurrences(of: ",", with: ".")
                                }
                                convertCurrency()
                            }
                            .keyboardType(.decimalPad)
                    }
                    
                    Section(header: Text(language == "en" ? "Conversion" : "Konwersja")) {
                        Text("\(conversionResult) \(converter.currencies[itemSelected2])")
                    }
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    
    private func convertCurrency() {
        guard let amountValue = Double(amount) else {
            conversionResult = "0.00"
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let result = converter.convert(amount: amountValue, from: itemSelected2, to: itemSelected1)
            
            DispatchQueue.main.async {
                conversionResult = result
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
