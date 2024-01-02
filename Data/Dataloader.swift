import SwiftUI

class DataLoader: ObservableObject {
    @Published var isDataLoaded = false

    func loadData() {
        let currencies = ["nokpln","usdpln","eurpln","gbppln",
                          "plnnok","usdnok","eurnok","gbpnok",
                          "plnusd","nokusd","eurusd","gbpusd",
                          "plngbp","nokgbp","eurgbp","usdgbp",
                          "plneur", "nokeur","gbpeur","usdeur"]
        DispatchQueue.global(qos: .background).async {
            getData(currencies: currencies)
            DispatchQueue.main.async {
                self.isDataLoaded = true
            }
        }
    }
}
