//
//  ExperiencePaymentViewModel.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import Foundation

class ExperiencePaymentViewModel: ObservableObject {
    @Published var card = PaymentCardModel(
        cardNumber: "1237 8789 5654 9878",
        cardHolderName: "Rohit Kamath",
        expiryDate: "10/30"
    )
    
    @Published var cvv: String = ""
}
