import SwiftUI

struct ContentView: View {

    
    @State private var showMainView = true
    @State private var showChartView = false
    @State private var showExchangeView = false
    @State private var showAuthorView = false
    
    var body: some View {
        NavigationView {
            Form {
                VStack {
                    Text("Main")
                }
            }
            .fullScreenCover(isPresented: $showChartView) {
                ChartView(showMainView: $showMainView, showExchangeView: $showExchangeView, showAuthorView: $showAuthorView, showChartView: $showChartView)
            }
            .fullScreenCover(isPresented: $showAuthorView) {
                AuthorView(showMainView: $showMainView, showExchangeView: $showExchangeView, showAuthorView: $showAuthorView, showChartView: $showChartView)
            }
            .fullScreenCover(isPresented: $showExchangeView) {
                ExchangeView(showMainView: $showMainView, showExchangeView: $showExchangeView, showAuthorView: $showAuthorView, showChartView: $showChartView)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: { createToolbar(showMainView: $showMainView, showExchangeView: $showExchangeView, showAuthorView: $showAuthorView, showChartView: $showChartView) })
        }
    }
}

#Preview { // Turn on iPhone view
    ContentView()
}
