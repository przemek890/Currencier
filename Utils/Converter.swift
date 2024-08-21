import Foundation
import SwiftUI

class CurrencyConverter: ObservableObject {
    @Published var currencies: [String] = Global.currencies
    @Published var currencyPairs: [String] = Global.currencypairs
    @Published var rates: [String: [String: Double]] = [:]
    
    init() {
        loadData()
    }
    
    func loadData() {
        DispatchQueue.global(qos: .background).async {
            let dataRows = loadCSVData(currencies: self.currencyPairs)
            
            DispatchQueue.main.async {
                self.processData(dataRows)
            }
        }
    }
    
    private func processData(_ dataRows: [DataRow]) {
        for currencyPair in currencyPairs {
            let filteredDataRows = dataRows.filter {
                $0.date != "Data" && $0.currency.lowercased().contains(currencyPair.lowercased())
            }
            
            if let dataRow = filteredDataRows.sorted(by: { $0.date > $1.date }).first {
                let averageRate = (dataRow.open + dataRow.close) / 2
                updateRates(for: currencyPair, with: averageRate)
            }
        }
    }
    
    private func updateRates(for currencyPair: String, with rate: Double) {
        let fromCurrency = String(currencyPair.suffix(3)).lowercased()
        let toCurrency = String(currencyPair.prefix(3)).lowercased()
        
        if rates[fromCurrency] == nil {
            rates[fromCurrency] = [toCurrency: rate]
        } else {
            rates[fromCurrency]?[toCurrency] = rate
        }
    }
    
    func convert(amount: Double, from: Int, to: Int) -> String {
        let fromCurrency = currencies[from].lowercased()
        let toCurrency = currencies[to].lowercased()
        
        if amount < 0 { return "0.00" }
        if fromCurrency == toCurrency { return String(format: "%.2f", amount) }
        
        guard let conversionRate = rates[fromCurrency]?[toCurrency] else {
            return "Conversion rate not available"
        }
        
        let conversion = amount * conversionRate
        return String(format: "%.2f", conversion)
    }
    
}
