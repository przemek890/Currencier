import SwiftUI

func createToolbar(showMainView: Binding<Bool>, showExchangeView: Binding<Bool>, showAuthorView: Binding<Bool>, showChartView: Binding<Bool>) -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
        Menu {
            Button("Main", action: {
                showExchangeView.wrappedValue = false
                showAuthorView.wrappedValue = false
                showChartView.wrappedValue = false
                showMainView.wrappedValue = true
            })
            Button("Exchange", action: {
                showMainView.wrappedValue = false
                showAuthorView.wrappedValue = false
                showChartView.wrappedValue = false
                showExchangeView.wrappedValue = true

            })
            Button("Author", action: {
                showMainView.wrappedValue = false
                showChartView.wrappedValue = false
                showExchangeView.wrappedValue = false
                showAuthorView.wrappedValue = true

            })
            Button("Charts", action: {
                showMainView.wrappedValue = false
                showAuthorView.wrappedValue = false
                showExchangeView.wrappedValue = false
                showChartView.wrappedValue = true
 
            })
        } label: {
            Label("Menu", systemImage: "line.horizontal.3")
        }
    }
}




