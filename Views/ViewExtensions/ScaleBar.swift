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
                    Text(String(format: "%.4f", value))
                        .font(.system(size: 10))
                        .alignmentGuide(.leading) { d in d[.bottom] }
                    Spacer()
                    Divider()
                        .frame(height: 50)
                }
            }
        }
        .frame(width: 50)
    }
}
