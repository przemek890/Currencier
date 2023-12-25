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
    
    @Binding var language: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(language == "en" ? "Language" : "Język")) {
                    Button(action: {
                        self.language = self.language == "en" ? "pl" : "en"
                    }) {
                        HStack {
                            Image(self.language == "en" ? "usd" : "pln")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                            Text(self.language == "en" ? "English" : "Polski")
                        }
                    }
                }
                Section(header: Text(language == "en" ? "Credits" : "Twórcy")) {
                   VStack {
                       Text(language == "en" ? "Author: Przemysław Janiszewski" : "Autor: Przemysław Janiszewski")
                   }
                   VStack {
                       Text(language == "en" ? "Index: 411890" : "Indeks: 411890")
                   }
                    VStack {
                        HStack {
                            Text(language == "en" ? "Powered by: " : "Zasilany przez: ")
                            Section {
                                Image("swift")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 20) // Wysokość tekstu
                            }
                            Section {
                                Image("swiftui")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 20) // Wysokość tekstu
                            }
                            Section {
                                Image("swiftuicharts")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 20) // Wysokość tekstu
                            }
                            Section {
                                Image("xcode")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 20) // Wysokość tekstu
                            }
                        }
                    }

                }

            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: { createToolbar(showMainView: $showMainView, showExchangeView: $showExchangeView, showAuthorView: $showAuthorView, showChartView: $showChartView,language: $language) })
        }
    }
}
