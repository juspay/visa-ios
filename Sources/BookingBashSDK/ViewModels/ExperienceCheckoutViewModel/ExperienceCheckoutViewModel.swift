//
//  ExperienceCheckoutViewModel.swift
//  VisaActivity
//
//  Created by Apple on 08/08/25.
//

import Foundation

class ExperienceCheckoutViewModel: ObservableObject {
    
    @Published var carousalData: [ExperienceDetailCarousalModel] = [
        ExperienceDetailCarousalModel(imageName: "Nature"),
        ExperienceDetailCarousalModel(imageName: "Nature"),
        ExperienceDetailCarousalModel(imageName: "Nature"),
        ExperienceDetailCarousalModel(imageName: "Nature"),
        ExperienceDetailCarousalModel(imageName: "Nature"),
        ExperienceDetailCarousalModel(imageName: "Nature")
    ]
    
    @Published var showAll: Bool = false
    
    @Published var allFeatures: [FeatureItem] = [
        FeatureItem(iconName: "clock", title: "Flexible time"),
        FeatureItem(iconName: "bolt.fill", title: "Instant confirmation"),
        FeatureItem(iconName: "ticket.fill", title: "Mobile ticket"),
        FeatureItem(iconName: "creditcard.fill", title: "Secure Payment"),
        FeatureItem(iconName: "star.fill", title: "Highly rated"),
        FeatureItem(iconName: "person.2.fill", title: "Group friendly"),
        FeatureItem(iconName: "person.2.fill", title: "Group friendly")
    ]
    
    @Published var fairSummaryData: [FareItem] = []
//        FareItem(title: "2 Adults x AED 295", value: "AED 590", isDiscount: false),
//        FareItem(title: "1 Child x AED 295", value: "AED 295", isDiscount: false),
//        FareItem(title: "Discount", value: "- AED 125", isDiscount: true)
//    ]
    
    @Published var items: [InfoItem] = [
        InfoItem(title: "Highlights", type: .highlights),
        InfoItem(title: "What's Included", type: .included),
        InfoItem(title: "What's Excluded", type: .excluded),
        InfoItem(title: "Cancellation Policy",type: .cancellation),
        InfoItem(title: "Know Before You Go", type: .know),
        InfoItem(title: "Where", type: .where_),
        InfoItem(title: "Reviews", type: .reviews),
        InfoItem(title: "Traveler Photos", type: .photos)
    ]
    
    @Published var inclusionExclusionData: [InfoDetailModel] = [
        InfoDetailModel(title: "What’s Included",
                        items: [
                            "Admission to LEGOLAND® Water Park",
                            "All activities",
                            "Unlimited rides"
                        ]),
        InfoDetailModel(title: "What’s excluded",
                        items: [
                            "Food and drinks",
                            "Hotel pick-up and drop-off"
                        ])
    ]
    
    @Published var highlights: [InfoDetailModel] = [
        InfoDetailModel(title: "Highlights",
                        items: [
                            "The Middle East's only Water Park designed for families with kids aged 2-12.",
                            "With 20 LEGO® themed water slides and attractions, it’s the most splashtastic family day out!"
                        ])
    ]
    
    @Published var cancellationPolicyData: [InfoDetailModel] = [
        InfoDetailModel(title: "Cancellation Policy",
                        items: [
                            "Tickets are non-cancellable, non-refundable and non-transferable."
                        ])
    ]
    
    @Published var knowBeforeGo: [InfoDetailModel] = [
        InfoDetailModel(title: "Know before you go",
                        shortDesciption: "It’s time to dive into a world at the LEGOLAND Water Park! What could be better than spending time with the family combining your creativity and exciting water attractions?",
                        items: [
                            "Kids below 3 enter the parks free of charge.",
                            "Important notes: does not operate on Wednesdays. The ticket can be used on any day within 90 days of issuance (considering the issue date and not the scheduled visit date). On arrival at Dubai Parks and Resorts make your way through Riverland, the dining and entertainment district that connects our theme parks to each other, and head to the entrance of LEGOLAND® Water Park to start your day. When you arrive at the park we recommend that you pick up a map and check the daily entertainment schedule posted in the park to plan out your day and make the most of your visit. All of the daytime live entertainment, rides, and attractions in the park are included in the price of your ticket so you are free to explore the park at your leisure with unlimited access to all of the rides on the day of your visit. Your ticket does not include transportation to Dubai Parks and Resorts so you will need to make use of Dubai's safe, clean, and cheap public transport. You can arrange transport through your hotel or simply take a local taxi.",
                            "The tickets can be used at any one of the parks within 90 days from the date of the booked activity.",
                            "Important notes: does not operate on Wednesdays.",
                            "Park hours are subject to change. All attractions will close 30 min prior to Park closing. Please note that some rides might be temporarily closed for annual maintenance, please check the park's website for the most current updates. The ticket can be used on any day within 90 days of issuance (considering the issue date and not the scheduled visit date). During severe weather conditions, we may need to temporarily close the attraction to ensure your safety. Please understand that we will not be able to offer refunds in case of inclement weather."
                        ])
    ]
    @Published var reviewResponse: ReviewTourDetailResponse?
    @Published var errorMessage: String?
    @Published var title: String?
    @Published var subtitle: String?
    
    let icons = [
        "bolt.fill"
    ]

}

extension ExperienceCheckoutViewModel {
    func fetchData() {
        guard let url = URL(string: "https://common-servicessit.vetravel.io/api/activities/2.0/review-details") else { return }
        let requestBody = ReviewDetailsRequestModel(
            uid: "688a6ef2d3545f348d1c720a",
            availability_id: "cd23671ff9d16aa56eddaf8ebac71aeba2407881c5c33f65cb3f20b30c274427",
            quote_id: "",
            enquiry_id: ""
        )
        
        NetworkManager.shared
            .post(url: url, body: requestBody) { (
                result: Result<ReviewTourDetailResponse,
                Error>
            ) in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let response):
                    if let responseData = response.data {
                        reviewResponse?.data = responseData
                        setUiData(responseData: response.data)
                    } else {
                        print("error in fetching data")
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func setUiData(responseData: ReviewTourDetailData?) {
        if let data = responseData {
            fairSummaryData = data.tourOption.rates.flatMap { rate in
                rate.price.pricePerAgeBand.map { band in
                    FareItem(
                        title: "\(band.travelerCount) x \(band.ageBand) AED \(band.pricePerTraveler)",
                        value: "AED \(band.totalBandPrice)",
                        isDiscount: false
                    )
                }
            }
            
            //            experienceDetail = ExperienceDetailModel(
            //                title: data.info.title,
            //                location: data.info.city,
            //                category: "",
            //                rating: Double(data.info.ratings),
            //                reviewCount: data.info.reviewCount
            //            )
            //
            //            allFeatures = data.info.additionalInfo.enumerated().map { index, title in
            //                let icon = icons[index % icons.count] // repeat icons if needed
            //                return FeatureItem(iconName: icon, title: title)
            //            }
            //
            //            aboutExperience = AboutExperienceModel(
            //                title: "About this experiences",
            //                description: data.info.description
            //            )
            //
            //            cancellationPolicy = data.info.cancellationPolicy.description
        }
    }
}
