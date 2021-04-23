//
//  ExchangeListItem.swift
//  Forex
//
//  Created by Subedi, Rikesh on 18/01/21.
//

import SwiftUI

struct ExchangeListItem: View {
    var name: String
    var value: Float
    var body: some View {
        HStack() {
            Text(name)
                .foregroundColor(.gray)
            Spacer()
            Text(String.init(format: "%.2f", value))
                .foregroundColor(.gray)
        }.padding(10)
    }
}

struct ExchangeListItem_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeListItem(name: "USD", value: 20.20)
    }
}
