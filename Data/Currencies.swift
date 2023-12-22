struct CurrencyConverter {
    
    let currencies = ["PLN","NOK","USD","EUR","GBP"]
    var plnRates: [String: Double] = ["PLN": 1.0]
    var nokRates: [String: Double] = ["NOK": 1.0]
    var usdRates: [String: Double] = ["USD": 1.0]
    var euroRates: [String: Double] = ["EUR": 1.0]
    var gbpRates: [String: Double] = ["GBP": 1.0]

    init() {
        let dataRows = loadCSVData(currencies: ["nokpln","usdpln","eurpln","gbppln"])
        
        for currency in currencies {
            if let dataRow = dataRows.last(where: { $0.currency.lowercased().contains(currency.lowercased()) }) {
                let averageRate = (dataRow.open + dataRow.close) / 2
                updateRates1(for: currency, with: averageRate)
            }
        }
        for currency in currencies {
            if let dataRow = dataRows.last(where: { $0.currency.lowercased().contains(currency.lowercased()) }) {
                let averageRate = (dataRow.open + dataRow.close) / 2
                updateRates2(for: currency)
            }
        }
    }

    mutating func updateRates1(for currency: String, with rate: Double) {
        switch currency {
        case "PLN":
            nokRates["PLN"] =  1 / rate
            usdRates["PLN"] =  1 / rate
            euroRates["PLN"] = 1 / rate
            gbpRates["PLN"] =  1 /  rate
            break
        case "NOK":
            plnRates["NOK"] = rate
            break
        case "USD":
            plnRates["USD"] = rate
            break
        case "EUR":
            plnRates["EUR"] = rate
            break
        case "GBP":
            plnRates["GBP"] = rate
            break
        default:
            print("Unsupported currency!")
        }
    }
    
    
    mutating func updateRates2(for currency: String) {
        switch currency {
        case "PLN":
            break
        case "NOK":
            usdRates["NOK"] = (plnRates["NOK"] ?? 1.0) / (plnRates["USD"] ?? 1.0)
            euroRates["NOK"] = (plnRates["NOK"] ?? 1.0) / (plnRates["EUR"] ?? 1.0)
            gbpRates["NOK"] = (plnRates["NOK"] ?? 1.0) / (plnRates["GBP"] ?? 1.0)
        case "USD":
            nokRates["USD"] =  (plnRates["USD"] ?? 1.0) / (plnRates["NOK"] ?? 1.0)
            euroRates["USD"] = (plnRates["USD"] ?? 1.0) / (plnRates["EUR"] ?? 1.0)
            gbpRates["USD"] = (plnRates["USD"] ?? 1.0) / (plnRates["GBP"] ?? 1.0)
        case "EUR":
            nokRates["EUR"] = (plnRates["EUR"] ?? 1.0) / (plnRates["NOK"] ?? 1.0)
            usdRates["EUR"] = (plnRates["EUR"] ?? 1.0) / (plnRates["USD"] ?? 1.0)
            gbpRates["EUR"] = (plnRates["EUR"] ?? 1.0) / (plnRates["GBP"] ?? 1.0)
        case "GBP":
            nokRates["GBP"] = (plnRates["GBP"] ?? 1.0) / (plnRates["NOK"] ?? 1.0)
            usdRates["GBP"] = (plnRates["GBP"] ?? 1.0) / (plnRates["USD"] ?? 1.0)
            euroRates["GBP"] = (plnRates["GBP"] ?? 1.0) / (plnRates["EUR"] ?? 1.0)
        default:
            print("Unsupported currency!")
        }
    }
    
    
    
    
    func convert(amount: Double, from: Int, to: Int) -> String {
        var conversion: Double = 1.0
        let selectedCurrency = currencies[from]
        let toCurrency = currencies[to]
        
        switch (selectedCurrency) {
        case "PLN":
            conversion = amount * (plnRates[toCurrency] ?? 0.0)
        case "NOK":
            conversion = amount * (nokRates[toCurrency] ?? 0.0)
        case "USD":
            conversion = amount * (usdRates[toCurrency] ?? 0.0)
        case "EUR":
            conversion = amount * (euroRates[toCurrency] ?? 0.0)
        case "GBP":
            conversion = amount * (gbpRates[toCurrency] ?? 0.0)
        default:
            print("Unsupported currency!")
        }
        
        return String(format: "%.2f", conversion)
    }
}
