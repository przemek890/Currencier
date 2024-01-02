import SwiftUI
//----------------------------------------------------

class DataLoader: ObservableObject {
    @Published var isDataLoaded = false


    func loadData() {
        DispatchQueue.global(qos: .background).async {
            getData(currencies: Global.currencypairs)
            DispatchQueue.main.async {
                self.isDataLoaded = true
            }
        }
    }
}
