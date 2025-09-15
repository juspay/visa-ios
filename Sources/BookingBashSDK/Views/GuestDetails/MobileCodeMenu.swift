//
//  MobileCode.swift
//  VisaActivity
//
//  Created by apple on 05/09/25.
//
import SwiftUI

struct MobileCodeMenu: View {
    @Binding var selectedCode: String

    // Updated list with flags (image URLs) + dial codes
    private let codes: [MobileCode] = [
        MobileCode(name: "UAE", maxCharLimit: 9, countryCode: 1, dialCode: "+971", image: "https://d33mtyizv24ggq.cloudfront.net/assets/ae.svg"),
        MobileCode(name: "China", maxCharLimit: 11, countryCode: 2, dialCode: "+86", image: "https://d33mtyizv24ggq.cloudfront.net/assets/cn.svg"),
        MobileCode(name: "Singapore", maxCharLimit: 8, countryCode: 3, dialCode: "+65", image: "https://d33mtyizv24ggq.cloudfront.net/assets/sg.svg"),
        MobileCode(name: "India", maxCharLimit: 10, countryCode: 4, dialCode: "+91", image: "https://d33mtyizv24ggq.cloudfront.net/assets/in.svg"),
        MobileCode(name: "Iceland", maxCharLimit: 7, countryCode: 5, dialCode: "+354", image: "https://d33mtyizv24ggq.cloudfront.net/assets/is.svg")
    ]

    var body: some View {
        Menu {
            ForEach(codes) { code in
                Button {
                    selectedCode = code.dialCode
                } label: {
                    HStack {
                        AsyncImage(url: URL(string: code.image)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 14)
                            } else if phase.error != nil {
                                Color.red.frame(width: 20, height: 14)
                            } else {
                                ProgressView()
                                    .frame(width: 20, height: 14)
                            }
                        }
                        Text(code.dialCode)
                    }
                }
            }
        } label: {
            HStack {
                if let selected = codes.first(where: { $0.dialCode == selectedCode }) {
                    AsyncImage(url: URL(string: selected.image)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 14)
                        } else if phase.error != nil {
                            Color.red.frame(width: 20, height: 14)
                        } else {
                            ProgressView()
                                .frame(width: 20, height: 14)
                        }
                    }
                }
                Text(selectedCode)
            }
            .padding(10)
            .frame(minWidth: 80)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray.opacity(0.4))
            )
        }
    }
}


