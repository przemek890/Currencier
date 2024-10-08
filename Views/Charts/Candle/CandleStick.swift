import SwiftUI
//----------------------------------------------------

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
    @AppStorage("isWhiteBlack") private var isWhiteBlack = false
    
    var body: some View {
        let scale = (maxHighValue - minLowValue) / 257
        let high_low = (high - low) / 2
        let g_high_g_low = (maxHighValue - minLowValue) / 2
        let off = CGFloat((high_low - g_high_g_low) / scale + (maxHighValue - high) / scale)
        VStack {
            Rectangle()
                .fill(isWhiteBlack ? (close > open ? Color.white : Color.black) : (close > open ? Color.green : Color.red))
                .frame(width: 1, height: CGFloat((high - max(open, close)) / scale))
                .border(isWhiteBlack && close > open ? Color.black : Color.clear, width: 1)
                .offset(y: 8)

            Rectangle()
                .fill(isWhiteBlack ? (close > open ? Color.white : Color.black) : (close > open ? Color.green : Color.red))
                .frame(width: 10, height: max(CGFloat(abs(open - close)), scale) / scale)
                .border(isWhiteBlack && close > open ? Color.black : Color.clear, width: 1)


            Rectangle()
                .fill(isWhiteBlack ? (close > open ? Color.white : Color.black) : (close > open ? Color.green : Color.red))
                .frame(width: 1, height: CGFloat((min(open, close) - low) / scale))
                .border(isWhiteBlack && close > open ? Color.black : Color.clear, width: 1)
                .offset(y: -8)
        }
        .offset(y: off)
        .padding(.horizontal, 7.5)
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
            .padding(.horizontal, 7.5)
            .background(isDarkMode ? Color.black : Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            .foregroundColor(isDarkMode ? Color.white : Color.black)
            .offset(y: off + 8)
            .overlay(
                Triangle()
                    .fill(isDarkMode ? Color.black : Color.white)
                    .frame(width: 20, height: 20)
                    .rotationEffect(.degrees(-90))
                    .offset(x: -7.5,y: off + 8),
                alignment: .leading
            )
        }
    }
}
