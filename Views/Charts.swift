import SwiftUI

struct CandleStick: View {
    var high: CGFloat
    var low: CGFloat
    var open: CGFloat
    var close: CGFloat

    var body: some View {
            VStack {
                // Górna cień świecy
                Rectangle()
                    .fill(close > open ? Color.green : Color.red)
                    .frame(width: 1, height: abs(high - max(open, close)))
                // Ciało świecy
                Rectangle()
                    .fill(close > open ? Color.green : Color.red)
                    .frame(width: 10, height: abs(open - close))
                // Dolna cień świecy
                Rectangle()
                    .fill(close > open ? Color.green : Color.red)
                    .frame(width: 1, height: abs(min(open, close) - low))
            }
    }
}

struct ChartView: View {
    @Binding var showChartView: Bool
    
    var body: some View {
        NavigationView {
            HStack {
                CandleStick(high: 100, low: 50, open: 75, close: 90)
                CandleStick(high: 120, low: 60, open: 110, close: 70)
                CandleStick(high: 80, low: 100, open: 25, close: 90)
                CandleStick(high: 20, low: 80, open: 110, close: 70)
                CandleStick(high: 100, low: 50, open: 75, close: 90)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {createToolbar(showChartView: $showChartView) })
        }
    }
}
    
