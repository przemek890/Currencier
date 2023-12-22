//
//  CurrencierApp.swift
//  Currencier
//
//  Created by przemek899 on 21/12/2023.
//

import SwiftUI

@main
struct CurrencierApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    let currencies = ["nokpln","usdpln","eurpln","gbppln"]
                    DispatchQueue.global(qos: .background).async {
                        getData(currencies: currencies)
                    }
                }
        }
    }
}


