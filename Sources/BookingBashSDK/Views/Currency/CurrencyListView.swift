//
//  CurrencyListView.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 26/11/25.
//

import SwiftUI
import SUINavigation

extension Notification.Name {
    static let currencyDidChange = Notification.Name("currencyDidChange")
}

struct CurrencyListView: View {
    @State private var searchText: String = ""
    @State private var selectedCurrency: CurrencyDataModel?
    
    @ObservedObject var viewModel: HomeViewModel

    @Environment(\.presentationMode) var presentationMode
    @OptionalEnvironmentObject private var navigationStorage: NavigationStorage?
    
    // MARK: – Filtering Logic
    var filteredCurrencies: [CurrencyDataModel] {
        let allCurrencies =
        (viewModel.currencyListData?.popular ?? []) +
        (viewModel.currencyListData?.other ?? [])
        
        if searchText.isEmpty {
            return allCurrencies
        }
        
        let search = searchText.lowercased()
        return allCurrencies.filter { item in
            item.name?.lowercased().contains(search) == true ||
            item.code?.lowercased().contains(search) == true
        }
    }
    
    var body: some View{
        ThemeTemplateView(needsScroll: false) {
            headerSection
        } content: {
            mainView
        }
        .dismissKeyboardOnTap()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let popular = viewModel.currencyListData?.popular,
                   let other = viewModel.currencyListData?.other {
                    let allCurrencyList = popular + other
                    selectedCurrency = allCurrencyList.first(where: { $0.code == currencyGlobal })
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }

    private var headerSection: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 8) {
                if let icon = ImageLoader.bundleImage(named: Constants.Icons.currencyWhite) {
                    icon
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.white)
                }
                Text("Currency")
                    .font(.custom("Lexend-Bold", size: 16))
                    .foregroundStyle(Color.white)
            }
            .padding(.horizontal, 12)
            .padding(.top, 16)
        }
    }

    private var mainView: some View {
        VStack {
            CommonSearchBarView(
                searchedText: $searchText,
                placeholder: "Search Currency..."
            )
            .padding(.top, 22)
            .padding(.horizontal)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    if searchText.isEmpty {
                        if let popularCurrency = viewModel.currencyListData?.popular, !popularCurrency.isEmpty {
                            CurrencySectionListView(
                                countryData: viewModel.currencyListData?.popular,
                                headerText: "Popular currencies",
                                selectedCurrency: $selectedCurrency)
                        }
                        if let otherCurrency = viewModel.currencyListData?.other, !otherCurrency.isEmpty {
                            CurrencySectionListView(
                                countryData: viewModel.currencyListData?.other,
                                selectedCurrency: $selectedCurrency)
                        }
                    } else {
                        CurrencySectionListView(
                            countryData: filteredCurrencies,
                            selectedCurrency: $selectedCurrency
                        )
                    }
                }
                .padding(.top, 30)
            }
            
            continueButton
        }
        .padding(.horizontal)
    }
    
    private var continueButton: some View {
        Button(action: {
            let oldCurrency = currencyGlobal
            let newCurrency = selectedCurrency?.code ?? "AED"

            guard oldCurrency != newCurrency else {
                presentationMode.wrappedValue.dismiss()
                return
            }

            // Update global
            UserDefaultsManager.shared.set(newCurrency, for: UserDefaultsKey.activeCurrency.rawValue)
            currencyGlobal = newCurrency

            // 🔔 Post notification
            NotificationCenter.default.post(
                name: .currencyDidChange,
                object: nil,
                userInfo: [
                    "currency": newCurrency
                ]
            )
            viewModel.showMenu = false
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Continue")
                .frame(maxWidth: .infinity)
                .padding()
                .font(.custom(Constants.Font.openSansBold, size: 12))
                .foregroundStyle(.white)
                .background(Color(hex: Constants.HexColors.primary))
                .cornerRadius(4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
//    CurrencyListView()
}
