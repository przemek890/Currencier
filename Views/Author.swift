//
//  Author.swift
//  Currencier
//
//  Created by przemek899 on 21/12/2023.
//

import SwiftUI


struct AuthorView: View {
    @Binding var showMainView: Bool
    @Binding var showExchangeView: Bool
    @Binding var showAuthorView: Bool
    @Binding var showChartView: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Credits")) {
                    VStack {
                        Text("Author: Przemysław Janiszewski")
                    }
                    VStack {
                        Text("Index: 411890")
                    }
                    VStack {
                        Text("Powered by: Xcode")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: { createToolbar(showMainView: $showMainView, showExchangeView: $showExchangeView, showAuthorView: $showAuthorView, showChartView: $showChartView) })
        }
    }
}

