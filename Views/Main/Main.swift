import SwiftUI
//----------------------------------------------------

struct ContentView: View {
    @StateObject private var dataLoader = DataLoader()

    @State private var selectedTab: Int = 0
    @State private var searchText: String = ""
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @ObservedObject var languageManager = LanguageManager.shared

    var body: some View {
        if dataLoader.isDataLoaded {
            TabView(selection: $selectedTab) {
                MainView(searchText: $searchText)
                    .tabItem {
                        Label(localizedText("Main"), systemImage: "house")
                    }
                    .tag(0)
                
                ExchangeView()
                    .tabItem {
                        Label(localizedText("Exchange"), systemImage: "arrow.left.arrow.right")
                    }
                    .tag(1)
                
                ChartView()
                    .tabItem {
                        Label(localizedText("Charts"), systemImage: "chart.bar")
                    }
                    .tag(2)
                
                OptionsView()
                    .tabItem {
                        Label(localizedText("Options"), systemImage: "gear")
                    }
                    .tag(3)
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        } else {
            Text(localizedText("Loading..."))
                .onAppear {
                    dataLoader.loadData()
                }
        }
    }
}

