import SwiftUI

func createToolbar(showMainView: Binding<Bool>, showExchangeView: Binding<Bool>,
                   showAuthorView: Binding<Bool>, showChartView: Binding<Bool>,language: Binding<String>) -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
        Menu {
            Button(language.wrappedValue == "en" ? "Main" : "Menu główne" , action: {
                showExchangeView.wrappedValue = false
                showAuthorView.wrappedValue = false
                showChartView.wrappedValue = false
                showMainView.wrappedValue = true
            })
            Button(language.wrappedValue == "en" ? "Exchange" : "Wymiana", action: {
                showMainView.wrappedValue = false
                showAuthorView.wrappedValue = false
                showChartView.wrappedValue = false
                showExchangeView.wrappedValue = true

            })
            Button(language.wrappedValue == "en" ? "Charts" : "Wykresy" , action: {
                showMainView.wrappedValue = false
                showAuthorView.wrappedValue = false
                showExchangeView.wrappedValue = false
                showChartView.wrappedValue = true
 
            })
            Button(language.wrappedValue == "en" ? "Options" : "Opcje", action: {
                showMainView.wrappedValue = false
                showChartView.wrappedValue = false
                showExchangeView.wrappedValue = false
                showAuthorView.wrappedValue = true

            })
        } label: {
            Label("Menu", systemImage: "line.horizontal.3")
        }
    }
}




