//
//  CurrencyTab.swift
//  Forex
//
//  Created by Subedi, Rikesh on 18/01/21.
//

import SwiftUI

struct CurrencyTab: View {
    var name: String
    var id: String
    @Binding var selection : String
    var onTap: (() -> Void)?
    var body: some View {
        VStack {
            Text(name)
                .font(.system(size: id == selection ? 20 : 18, weight: .bold))
                .foregroundColor(id == selection ? .black : .blue)
                .onTapGesture {
                    selection = id
                    onTap?()
                }
                .padding(.leading, 5)
                .padding(.top, 5)
        }
    }
}

struct CurrencyTab_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyTab(name: "USD", id: "USD", selection: .constant("USD"))
    }
}
