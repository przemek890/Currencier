import SwiftUI
//----------------------------------------------------

struct ContentView: View {
    @StateObject private var dataLoader = DataLoader()

    @State private var selectedTab: Int = 0
    @State private var language: String = "en"
    @State private var searchText: String = ""
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    var body: some View {
        if dataLoader.isDataLoaded {
            TabView(selection: $selectedTab) {
                MainView(searchText: $searchText, language: $language)
                    .tabItem {
                        Label(language == "en" ? "Main" : "Menu główne", systemImage: "house")
                    }
                    .tag(0)
                
                ExchangeView(language: $language)
                    .tabItem {
                        Label(language == "en" ? "Exchange" : "Wymiana", systemImage: "arrow.left.arrow.right")
                    }
                    .tag(1)
                
                ChartView(language: $language)
                    .tabItem {
                        Label(language == "en" ? "Charts" : "Wykresy", systemImage: "chart.bar")
                    }
                    .tag(2)
                
                OptionsView(language: $language)
                    .tabItem {
                        Label(language == "en" ? "Options" : "Opcje", systemImage: "gear")
                    }
                    .tag(3)
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        } else {
            Text(language == "en" ? "Loading..." : "Ładowanie")
                .onAppear {
                    dataLoader.loadData()
                }
        }
    }
}

