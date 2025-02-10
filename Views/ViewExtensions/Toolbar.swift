import SwiftUI
//----------------------------------------------------

func createToolbar(showMainView: Binding<Bool>, showExchangeView: Binding<Bool>,
                   showOptionsView: Binding<Bool>, showChartView: Binding<Bool>) -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
        Menu {
            Button(localizedText("Main"), action: {
                showExchangeView.wrappedValue = false
                showOptionsView.wrappedValue = false
                showChartView.wrappedValue = false
                showMainView.wrappedValue = true
            })
            Button(localizedText("Exchange"), action: {
                showMainView.wrappedValue = false
                showOptionsView.wrappedValue = false
                showChartView.wrappedValue = false
                showExchangeView.wrappedValue = true

            })
            Button(localizedText("Charts"), action: {
                showMainView.wrappedValue = false
                showOptionsView.wrappedValue = false
                showExchangeView.wrappedValue = false
                showChartView.wrappedValue = true
 
            })
            Button(localizedText("Options"), action: {
                showMainView.wrappedValue = false
                showChartView.wrappedValue = false
                showExchangeView.wrappedValue = false
                showOptionsView.wrappedValue = true

            })
        } label: {
            Label("Menu", systemImage: "line.horizontal.3")
        }
    }
}




