import SwiftUI

func createToolbar(showChartView: Binding<Bool>) -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
        Menu {
            Button("Main Menu", action: {
                showChartView.wrappedValue = false
            })
            Button("Currencies", action: {})
            Button("Author", action: {})
            Button("Charts", action: {
                showChartView.wrappedValue = true
            })
        } label: {
            Label("Menu", systemImage: "line.horizontal.3")
        }
    }
}
