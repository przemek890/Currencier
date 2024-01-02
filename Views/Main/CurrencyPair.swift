import SwiftUI
//----------------------------------------------------

struct CurrencyPairView: View {
    var currency1: String
    var currency2: String
    var high: Double
    var low: Double
    var open: Double
    var close: Double
    var isSelected: Bool
    @Binding var language: String
    
    
    var body: some View {
        HStack {
            HStack {
                Image(currency1)
                Image(currency2)
                    .offset(x: -17)
            }
            .scaleEffect(0.40)
            Spacer()
            if isSelected {
                let change = close - open
                Text("\(language == "en" ? "Change from last day: " : "Zmiana wzgledem ostatniego dnia: ")\(String(format: "%.2f", change * 100 / open))%")
                    .font(.system(size: 14))
                    .foregroundColor(change > 0 ? .green : .red)
            } else {
                Text("\(String(format: open >= 100 ? "%.2f" : open >= 10 ? "%.3f" : "%.4f", open))")
                    .font(.system(size: 14))
                Spacer()
                Text("\(String(format: high >= 100 ? "%.2f" : high >= 10 ? "%.3f" : "%.4f", high))")
                    .font(.system(size: 14))
                Spacer()
                Text("\(String(format: low >= 100 ? "%.2f" : low >= 10 ? "%.3f" : "%.4f", low))")
                    .font(.system(size: 14))
                Spacer()
                Text("\(String(format: close >= 100 ? "%.2f" : close >= 10 ? "%.3f" : "%.4f", close))")
                    .font(.system(size: 14))
            }
        }
        .frame(height: 50) // Zwiększ wysokość wiersza
    }
}
