//
//  HomeScreen.swift
//  Forex
//
//  Created by Subedi, Rikesh on 15/01/21.
//

import SwiftUI

struct HomeScreen: View {
    @Environment(\.managedObjectContext) private var viewContextf
    var numberFormatter:NumberFormatter = {
        var formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    @ObservedObject var viewModel: HomeScreenViewModel
    @State private var liveAmount: NSNumber = 1.0
    @State var src: String = "USD"
    @State var actualAmountString = "1"
    var body: some View {
        let binding = Binding(
            get: {
                self.actualAmountString
            },
            set: {
                self.actualAmountString = $0
                self.liveAmount = self.numberFormatter.number(from: $0) ?? 0
                // Add call to API here0
            }
        )
        ZStack {
            Color.init(red: 0.99, green: 0.99, blue: 0.99)
            VStack(alignment: .leading) {
                VStack {
                    GeometryReader { geometry in
                        ZStack {
                            TextField("Amount", text:  binding)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                                .font(.title)
                                .padding(.trailing, 15)
                                .border(Color.gray, width: 0.5)
                            Text(src)
                                .foregroundColor(.gray)
                                .offset(x: -(geometry.size.width) / 2 + 40, y: 0)

                        }
                        .padding(10)
                    }
                    .frame(height:50)


                    ScrollViewReader { scrollViewProxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(alignment:.center) {
                                ForEach(viewModel.currencyList, id: \.self) { currency in
                                    CurrencyTab(name: currency, id: currency, selection: $src) {
                                        viewModel.fetchExchanges(src: src)
                                        scrollViewProxy.scrollTo(src)
                                    }
                                }
                            }
                            .onReceive(viewModel.$currencyList, perform: { list in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation(Animation.linear(duration: 1)) {
                                        scrollViewProxy.scrollTo(src, anchor: .center)
                                    }

                                }

                            })
                            .padding(10)
                            .frame(height: 30)
                        }

                    }


                }
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.exchanges?.keys.sorted() ?? [], id: \.self) { key in
                            ExchangeListItem(name: key, value: (viewModel.exchanges?[key] ?? 0) * Float(truncating: liveAmount))
                                .frame(height: 40)
                                .background(Color.white)
                                //.border(Color.gray, width: 1)
                                .cornerRadius(3.0)
                                .shadow(radius: 3)
                                .zIndex(5)
                        }
                    }
                    .padding(10)
                }

                Spacer()

            }
            .contentShape(Rectangle())
            .onTapGesture {}
            .onLongPressGesture(minimumDuration: 1, maximumDistance: 0) { (pressed) in
                if pressed {
                    self.endEditing()
                }
            } perform: {

            }
            .onAppear {
                viewModel.fetchExchanges(src: src)
            }

        }

    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var viewmodel:HomeScreenViewModel = {
        let viewModel = HomeScreenViewModel(repository: ExchangeRepository(persistentController: PersistenceController.preview))
        return viewModel
    }()
    static var previews: some View {
        HomeScreen(viewModel: viewmodel)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

