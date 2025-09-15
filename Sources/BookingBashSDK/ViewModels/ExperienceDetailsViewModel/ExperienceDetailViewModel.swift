//
//  ExperienceDetailViewModel.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import Foundation

class ExperienceDetailViewModel: ObservableObject {
    @Published var carousalData: [ExperienceDetailCarousalModel] = []
    @Published var isLoading: Bool = false
    
    @Published var experienceDetail: ExperienceDetailModel?
    @Published var isViewMoreExpanded = false
    @Published var allFeatures: [FeatureItem] = []
    @Published var sortRatingsOptions: [SortOption] = [
        .init(title: "Most Relevant"),
        .init(title: "Ratings - High to low"),
        .init(title: "Ratings - Low to high")
    ]
    
    @Published var selectedOption: SortOption?
    @Published var aboutExperience: AboutExperienceModel? = nil
    
    var cancellationPolicy: String = ""
    
    @Published var popularDays: [PopularDayModel] = [
        PopularDayModel(title: "Sun", isHighlighted: false),
        PopularDayModel(title: "Mon", isHighlighted: false),
        PopularDayModel(title: "Tue", isHighlighted: true),
        PopularDayModel(title: "Wed", isHighlighted: true),
        PopularDayModel(title: "Thu", isHighlighted: false),
        PopularDayModel(title: "Fri", isHighlighted: false),
        PopularDayModel(title: "Sat", isHighlighted: false),
    ]
    
    @Published var items: [InfoItem] = [
        InfoItem(title: "Highlights", type: .highlights),
        InfoItem(title: "What's Included", type: .included),
        InfoItem(title: "What's Excluded", type: .excluded),
        InfoItem(title: "Cancellation Policy",type: .cancellation),
        InfoItem(title: "Know Before You Go", type: .know),
//        InfoItem(title: "Where", type: .where_),
        InfoItem(title: "Reviews", type: .reviews),
        InfoItem(title: "Traveler Photos", type: .photos)
    ]
    
    @Published var inclusionExclusionData: [InfoDetailModel] = []
    
    @Published var highlights: [InfoDetailModel] = [
        InfoDetailModel(title: "Highlights",
                        items: [
                            "The Middle East's only Water Park designed for families with kids aged 2-12.",
                            "With 20 LEGO® themed water slides and attractions, it’s the most splashtastic family day out!"
                        ])
    ]
    
    @Published var cancellationPolicyData: [InfoDetailModel] = []
    
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
    
    @Published var reviews: [ReviewsModel] = [
        ReviewsModel(
            rating: 5,
            title: "5/5",
            body: "It was a memorable experience, my kids enjoyed it so much. it is all they tak about. the facilities were clean, hospitality of customer service personnel. It was a memorable experience, my kids enjoyed it so much. it is all they tak about. the facilities were clean, hospitality of customer service personnel",
            images: ["Nature", "Nature", "Nature", "Nature"],
            userName: "Sophia",
            date: "19 Jun 2025"
        ),
        ReviewsModel(
            rating: 5,
            title: "5/5",
            body: "It was a memorable experience, my kids enjoyed it so much. it is all they tak about. the facilities were clean, hospitality of customer service personnel. It was a memorable experience, my kids enjoyed it so much. it is all they tak about. the facilities were clean, hospitality of customer service personnel",
            images: ["Nature", "Nature", "Nature", "Nature"],
            userName: "Sophia",
            date: "19 Jun 2025"
        ),
        ReviewsModel(
            rating: 5,
            title: "5/5",
            body: "It was a memorable experience, my kids enjoyed it so much. it is all they tak about. the facilities were clean, hospitality of customer service personnel. It was a memorable experience, my kids enjoyed it so much. it is all they tak about. the facilities were clean, hospitality of customer service personnel",
            images: ["Nature", "Nature", "Nature", "Nature", "Nature", "Nature", "Nature"],
            userName: "Sophia",
            date: "19 Jun 2025"
        )
    ]
    
    @Published var images: [TravellerPhotosModel] = [
        TravellerPhotosModel(imageName: "Nature", overlayText: nil),
        TravellerPhotosModel(imageName: "Nature", overlayText: nil),
        TravellerPhotosModel(imageName: "Nature", overlayText: nil),
        TravellerPhotosModel(imageName: "Nature", overlayText: nil),
        TravellerPhotosModel(imageName: "Nature", overlayText: nil),
        TravellerPhotosModel(imageName: "Nature", overlayText: "+387")
    ]
    
    @Published var price: String = ""
    @Published var location: String = ""
    @Published var priceSuffix: String = "/Person"
    @Published var buttonText: String = "Check Availability"
    @Published var errorMessage: String?
    @Published var apiReviewResponseData: DetailResponseData?
    
    let icons = [
        "bolt.fill"
    ]
    
    init() {
        selectedOption = sortRatingsOptions.first
    }
    
    func fetchReviewData(productCode: String, currency: String) {
        isLoading = true
        guard let url = URL(string: "https://travelapi-sandbox.bookingbash.com/services/api/activities/2.0/details") else {
            isLoading = false
            return
        }
        
        let requestBody = ExperienceRequest(
            product_code: productCode,
            currency: currency
        )
        let headers = [
            "Content-Type": "application/json",
            "Authorization": TokenProvider.getAuthHeader() ?? "",
            "token": encryptedPayload
        ]
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<DetailExrienceApiResponse, Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    if let responseData = response.data {
                        self.setUiData(responseData: responseData)
                    } else {
                        print("error in fetching data")
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func setUiData(responseData: DetailResponseData?) {
        if let data = responseData {
            // Set dynamic carousel images from API response
            carousalData = data.info.images.map { ExperienceDetailCarousalModel(imageUrl: $0.url) }
            
            price = "\(data.price.currency) \(data.price.totalAmount)"
            location = "\(data.info.city) \(data.info.country)"
            experienceDetail = ExperienceDetailModel(
                title: data.info.title,
                location: "\(data.info.city) \(" - ")\(data.info.country)",
                category: "",
                rating: Double(data.info.ratings),
                reviewCount: data.info.reviewCount
            )
            
            allFeatures = data.info.additionalInfo.enumerated().map { index, title in
                let icon = icons[index % icons.count]
                return FeatureItem(iconName: icon, title: title)
            }
            
            aboutExperience = AboutExperienceModel(
                title: "About this experiences",
                description: data.info.description
            )
            
            cancellationPolicy = data.info.cancellationPolicy.description
            print(data.info.cancellationPolicy.description)
            // Make cancellation policy dynamic
            cancellationPolicyData = [
                InfoDetailModel(title: "Cancellation Policy",
                                items: [data.info.cancellationPolicy.description])
            ]
            
            inclusionExclusionData = [
                InfoDetailModel(title: "What's Included",
                                items: data.info.inclusions
                               ),
                InfoDetailModel(title: "What's excluded",
                                items: data.info.exclusions
                               )
                
            ]
        }
    }
}
