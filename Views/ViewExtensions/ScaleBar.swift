import SwiftUI
//----------------------------------------------------

struct ScaleBarView: View {
    var minLowValue: Double
    var maxHighValue: Double

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0..<7, id: \.self) { index in
                let value = (maxHighValue - minLowValue) / 6 * Double(6 - index) + minLowValue
                HStack {
                    Text(String(format: value >= 100 ? "%.2f" : value >= 10 ? "%.3f" : "%.4f", value))
                        .font(.system(size: 8))
                        .alignmentGuide(.leading) { d in d[.bottom] }
                    Spacer()
                    Divider()
                        .frame(height: 37.5)
                }
            }
        }
        .frame(width: 37.5)
    }
}

