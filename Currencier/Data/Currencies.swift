struct CurrencyConverter {
    
    let currencies = ["PLN","NOK","USD","EUR","GBP"]
    
    let currencypairs = ["nokpln","usdpln","eurpln","gbppln",
                         "plnnok","usdnok","eurnok","gbpnok",
                         "plnusd","nokusd","eurusd","gbpusd",
                         "plngbp","nokgbp","eurgbp","usdgbp"]
    
    var plnRates: [String: Double] = ["PLN": 1.0]
    var nokRates: [String: Double] = ["NOK": 1.0]
    var usdRates: [String: Double] = ["USD": 1.0]
    var eurRates: [String: Double] = ["EUR": 1.0]
    var gbpRates: [String: Double] = ["GBP": 1.0]

    init() {
        
        
        let dataRows = loadCSVData(currencies: currencypairs)
        
        for currency in currencypairs {
            if let dataRow = dataRows.last(where: { $0.currency.lowercased().contains(currency.lowercased()) }) {
                let averageRate = (dataRow.open + dataRow.close) / 2
                updateRates(for: currency, with: averageRate)
            }
        }
    }


    mutating func updateRates(for currency: String, with rate: Double) {
        switch currency {
        case "plnnok": nokRates["PLN"] = rate; break
        case "plnusd": usdRates["PLN"] = rate; break
        case "plneur": eurRates["PLN"] = rate; break
        case "plngbp": gbpRates["PLN"] = rate; break
            
        case "nokpln": plnRates["NOK"] = rate; break
        case "nokgbp": gbpRates["NOK"] = rate; break
        case "nokusd": usdRates["NOK"] = rate; break
        case "nokeur": eurRates["NOK"] = rate; break
            
        case "usdpln": plnRates["USD"] = rate; break
        case "usdnok": nokRates["USD"] = rate; break
        case "usdeur": eurRates["USD"] = rate; break
        case "usdgbp": gbpRates["USD"] = rate; break
            
        case "eurpln": plnRates["EUR"] = rate; break
        case "eurnok": nokRates["EUR"] = rate; break
        case "eurusd": usdRates["EUR"] = rate; break
        case "eurgbp": gbpRates["EUR"] = rate; break
            
        case "gbppln": plnRates["GBP"] = rate; break
        case "gbpnok": nokRates["GBP"] = rate; break
        case "gbpusd": usdRates["GBP"] = rate; break
        case "gbpeur": eurRates["GBP"] = rate; break
            
        default: print("Unsupported currency!")
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
            conversion = amount * (eurRates[toCurrency] ?? 0.0)
        case "GBP":
            conversion = amount * (gbpRates[toCurrency] ?? 0.0)
        default:
            print("Unsupported currency!")
        }
        
        return String(format: "%.2f", conversion)
    }
}
