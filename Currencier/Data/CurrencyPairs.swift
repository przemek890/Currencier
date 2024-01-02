import SwiftUI

struct CurrencyPairsView: View {
    var body: some View {
        Section(header: Text("Main currency pairs")) {
            HStack {
                Image("nok")
                Image("pln")
                .offset(x: -17)
            }
            
            HStack {
                Image("usd")
                Image("pln")
                .offset(x: -17)
            }
            
            HStack {
                Image("eur")
                Image("pln")
                .offset(x: -17)
            }
            
            HStack {
                Image("gbp")
                Image("pln")
                .offset(x: -17)
            }
            HStack {
                Image("pln")
                Image("nok")
                .offset(x: -17)
            }
            
            HStack {
                Image("usd")
                Image("nok")
                .offset(x: -17)
            }
            
            HStack {
                Image("eur")
                Image("nok")
                .offset(x: -17)
            }
            
            HStack {
                Image("gbp")
                Image("nok")
                .offset(x: -17)
            }
            ////////////////////////////////////////
            HStack {
                Image("pln")
                Image("usd")
                .offset(x: -17)
            }
            
            HStack {
                Image("nok")
                Image("usd")
                .offset(x: -17)
            }
            
            HStack {
                Image("eur")
                Image("usd")
                .offset(x: -17)
            }
            
            HStack {
                Image("gbp")
                Image("usd")
                .offset(x: -17)
            }
            HStack {
                Image("pln")
                Image("eur")
                .offset(x: -17)
            }
            
            HStack {
                Image("nok")
                Image("eur")
                .offset(x: -17)
            }
            
            HStack {
                Image("usd")
                Image("eur")
                .offset(x: -17)
            }
            
            HStack {
                Image("gbp")
                Image("eur")
                .offset(x: -17)
            }
            HStack {
                Image("pln")
                Image("gbp")
                .offset(x: -17)
            }
            
            HStack {
                Image("nok")
                Image("gbp")
                .offset(x: -17)
            }
            
            HStack {
                Image("usd")
                Image("gbp")
                .offset(x: -17)
            }
            
            HStack {
                Image("eur")
                Image("gbp")
                .offset(x: -17)
            }
        }
    }
}

