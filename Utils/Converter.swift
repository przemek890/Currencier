struct CurrencyConverter {
    let currencies = Global.currencies
    let currencyPairs = Global.currencypairs
    
    var rates: [String: [String: Double]] = [:]

    init() {
        let dataRows = loadCSVData(currencies: currencyPairs)
        
        for currencyPair in currencyPairs {
            // Filtrujemy rekordy, które mają prawidłową datę i zawierają daną parę walutową
            let filteredDataRows = dataRows.filter { $0.date != "Data" && $0.currency.lowercased().contains(currencyPair.lowercased()) }
            
            // Bierzemy rekord z najnowszą datą
            if let dataRow = filteredDataRows.sorted(by: { $0.date > $1.date }).first {
                let averageRate = (dataRow.open + dataRow.close) / 2
                updateRates(for: currencyPair, with: averageRate)
            }
        }
    }

    mutating func updateRates(for currencyPair: String, with rate: Double) {
        let fromCurrency = String(currencyPair.suffix(3))
        let toCurrency = String(currencyPair.prefix(3))
        
        if rates[fromCurrency] == nil {
            rates[fromCurrency] = [toCurrency: rate]
        } else {
            rates[fromCurrency]?[toCurrency] = rate
        }
    }

    func convert(amount: Double, from: Int, to: Int) -> String {
        let fromCurrency = currencies[from]
        let toCurrency = currencies[to]
        
        if fromCurrency.lowercased() == toCurrency.lowercased() {
            return String(format: "%.2f", amount)
        }
        
        let conversion = amount * (rates[fromCurrency.lowercased()]?[toCurrency.lowercased()] ?? 0.0)
        
        return String(format: "%.2f", conversion)
    }
}
