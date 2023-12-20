// Model danych
struct CurrencyConverter {
    let currencies = ["PLN","NOK","USD","EUR","GBP"]
    let euroRates = ["PLN": 4.5,"NOK":11.8,"USD": 1.15, "EUR": 1.0, "GBP": 0.84]
    let usdRates = ["PLN": 1.0,"NOK":11.8,"USD": 1.15, "EUR": 1.0, "GBP": 0.84]
    let gbpRates = ["PLN": 4.5,"NOK":11.8,"USD": 1.15, "EUR": 1.0, "GBP": 0.84]
    let plnRates = ["PLN": 4.5,"NOK":11.8,"USD": 1.15, "EUR": 1.0, "GBP": 0.84]
    let nokRates = ["PLN": 4.5,"NOK":11.8,"USD": 1.15, "EUR": 1.0, "GBP": 0.84]
    
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
