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
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(language == "en" ? "Theme" : "Motyw")) {
                    HStack {
                        Image("lighting")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                        Spacer().frame(width: 20)
                        Toggle(isOn: $isDarkMode) {
                            if isDarkMode == false {
                                Text(language == "en" ? "Light mode" : "Tryb jasny")

                            }
                            else {
                                Text(language == "en" ? "Dark mode" : "Tryb ciemny")
                            }
                        }
                    }
                }
                Section(header: Text(language == "en" ? "Language" : "Język")) {
                    Button(action: {
                        self.language = self.language == "en" ? "pl" : "en"
                    }) {
                        HStack {
                            Image(self.language == "en" ? "usd" : "pln")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                            Spacer().frame(width: 20)
                            Text(self.language == "en" ? "English" : "Polski")
                        }
                    }
                }
                Section(header: Text(language == "en" ? "Author" : "Autor")) {
                    VStack {
                        HStack{
                            Image("github")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                            Spacer().frame(width: 20)
                            Link("Przemysław Janiszewski", destination: URL(string: "https://github.com/przemek890")!)
                        }
                    }
                }
                Section(header: Text(language == "en" ? "Powered by: " : "Zasilane przez: ")) {
                        HStack{
                            Image("apple")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                            Spacer().frame(width: 75)
                            Link("Apple", destination: URL(string: "https://www.apple.com/")!)
                        }
                        HStack{
                            Image("swift")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                            Spacer().frame(width: 70)
                            Link("Swift", destination: URL(string: "https://developer.apple.com/swift/")!)
                        }
                        HStack {
                            Image("swiftui")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                            Spacer().frame(width: 70)
                            Link("SwiftUI", destination: URL(string: "https://developer.apple.com/xcode/swiftui/")!)
                        }
                        HStack {
                            Image("swiftuicharts")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                            Spacer().frame(width: 70)
                            Link("SwiftUICharts", destination: URL(string: "https://github.com/willdale/SwiftUICharts")!)
                        }
                        HStack {
                            Image("alamofire")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                            Spacer().frame(width: 22)
                            Link("Alamofire", destination: URL(string: "https://github.com/Alamofire")!)
                        }
                        HStack {
                            Image("xcode")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                            Spacer().frame(width: 70)
                            Link("Xcode", destination: URL(string: "https://developer.apple.com/xcode/")!)
                        }
                    }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: { createToolbar(showMainView: $showMainView, showExchangeView: $showExchangeView, showAuthorView: $showAuthorView, showChartView: $showChartView,language: $language) })
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
