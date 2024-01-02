import SwiftUI

struct CandleStick: View {
    var id: Int
    var date: String
    var high: Double
    var low: Double
    var open: Double
    var close: Double
    var curr: String
    var maxHighValue: Double
    var minLowValue: Double
    @Binding var selectedCandle: Int?
    @Binding var selectedCurrency: String?
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        let scale = (maxHighValue - minLowValue) / 340
        let midValue = (maxHighValue + minLowValue) / 2
        VStack {
            // Górna cień świecy
            Rectangle()
                .fill(close > open ? Color.green : Color.red)
                .frame(width: 1, height: CGFloat((high - max(open, close)) / scale))
                .offset(y: CGFloat((midValue - max(open, close)) / scale) + 8)
            // Ciało świecy
            Rectangle()
                .fill(close > open ? Color.green : Color.red)
                .frame(width: 10, height: max(CGFloat(abs(open - close)), scale/2) / scale)
                .offset(y: CGFloat((midValue - max(open, close)) / scale))
            // Dolna cień świecy
            Rectangle()
                .fill(close > open ? Color.green : Color.red)
                .frame(width: 1, height: CGFloat((min(open, close) - low) / scale))
                .offset(y: CGFloat((midValue - max(open, close)) / scale) - 8)
        }
        .padding(.horizontal, 10)
        .offset(y: 15)
        if selectedCandle == id && curr == selectedCurrency {
            VStack {
                Text("Currency: \(curr) [\(date)]")
                    .font(.system(size: 12))
                    .bold()
                Text("Open: \(open)")
                    .font(.system(size: 12))
                Text("High: \(high)")
                    .font(.system(size: 12))
                Text("Low: \(low)")
                    .font(.system(size: 12))
                Text("Close: \(close)")
                    .font(.system(size: 12))
            }
            .padding(.horizontal, 10)
            .background(isDarkMode ? Color.black : Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            .foregroundColor(isDarkMode ? Color.white : Color.black)
            .offset(y: CGFloat((midValue - max(open, close)) / scale) + 8)
            .overlay(
                Triangle()
                    .fill(isDarkMode ? Color.black : Color.white)
                    .frame(width: 20, height: 20)
                    .rotationEffect(.degrees(-90))
                    .offset(x: -10,y: CGFloat((midValue - max(open, close)) / scale) + 8),
                alignment: .leading
            )
        }
    }
}