//
//  SearchCountryBottomSheetView.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 22/11/25.
//

import SwiftUI

struct SearchCountryBottomSheetView: View {
    let countries: [MobileCode]
    @Binding var isPresented: Bool
    var onSelectCode: (MobileCode?) -> Void

    @State private var searchText: String = ""
    @State private var selectedCountry: MobileCode? = nil
    @State private var isContentVisible: Bool = false

    var filteredCountries: [MobileCode] {
        if searchText.isEmpty { return countries }
        return countries.filter { $0.name.lowercased().contains(searchText.lowercased()) || $0.dialCode.contains(searchText) }
    }

    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    hideKeyboard()
                }

            VStack(spacing: 18) {
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.gray)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                }
                
                CommonSearchBarView(searchedText: $searchText)
                    .transaction { $0.animation = nil }

                VStack {
                    Spacer()
                    if filteredCountries.isEmpty {
                        VStack {
                            
                        }
                    } else {
                        ScrollView(showsIndicators: false) {
                            LazyVStack(alignment: .leading, spacing: 0) {
                                ForEach(filteredCountries) { country in
                                    HStack {
                                        if let radioImage = ImageLoader.bundleImage(named: (selectedCountry?.countryCode == country.countryCode)
                                              ? Constants.Icons.radioButtonChecked
                                              : Constants.Icons.radioButtonUnchecked) {
                                            radioImage
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .foregroundStyle(selectedCountry?.countryCode == country.countryCode ? Color(hex: Constants.HexColors.primary) : Color(hex: Constants.HexColors.neutral))
                                        }
            
                                        if let url = URL(string: country.image) {
                                            SVGImageView(url: url)
                                                .frame(width: 24, height: 16)
                                                .aspectRatio(contentMode: .fill)
                                        }

                                        Text(country.name)
                                            .font(.custom(Constants.Font.openSansRegular, size: 14))
                                            .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))

                                        Text("(\(country.dialCode))")
                                            .font(.custom(Constants.Font.openSansRegular, size: 14))
                                            .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))

                                        Spacer()
                                    }
                                    .padding()
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectedCountry = country
                                        UIApplication.shared.endEditing()
                                    }
                                    if country.id != filteredCountries.last?.id {
                                        Rectangle()
                                            .fill(Color.white)
                                            .frame(height: 1)
                                            .padding(.horizontal, 16)
                                    }
                                }
                            }
                        }
                    }

                    if !filteredCountries.isEmpty {
                        Button(action: {
                            onSelectCode(selectedCountry)
                            isPresented = false
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
                        .padding([.horizontal, .bottom])
                    }
                }
                .background(Color(hex: Constants.HexColors.surfaceWeakest))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding([.horizontal, .top])
            .opacity(isContentVisible ? 1 : 0)
            .animation(.easeOut(duration: 0.15), value: isContentVisible)
        }
        .onAppear {
            isContentVisible = true
        }
        .dismissKeyboardOnTap()
    }
}

#Preview {
    let mockCountries: [MobileCode] = [
        MobileCode(
            name: "India",
            maxCharLimit: 10,
            countryCode: 91,
            dialCode: "+91",
            image: "https://d33mtyizv24ggq.cloudfront.net/assets/in.svg"
        ),
        MobileCode(
            name: "United States",
            maxCharLimit: 10,
            countryCode: 1,
            dialCode: "+1",
            image: "https://d33mtyizv24ggq.cloudfront.net/assets/in.svg"
        ),
        MobileCode(
            name: "United Kingdom",
            maxCharLimit: 10,
            countryCode: 44,
            dialCode: "+44",
            image: "https://d33mtyizv24ggq.cloudfront.net/assets/in.svg"
        )
    ]
    SearchCountryBottomSheetView(countries: mockCountries, isPresented: .constant(true)) {_ in }
}
