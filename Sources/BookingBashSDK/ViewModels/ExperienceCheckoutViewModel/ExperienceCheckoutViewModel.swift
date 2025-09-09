//
//  ExperienceCheckoutViewModel.swift
//  VisaActivity
//
//  Created by Apple on 08/08/25.
//

import Foundation

class ExperienceCheckoutViewModel: ObservableObject {
    @Published var orderNo: String?
    @Published var shouldNavigateToPayment: Bool = false
    @Published private var shouldNavigateToConfirmation: Bool = false
    
    
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
    
    @Published var subtitle: String?
    
    let icons = [
        "bolt.fill"
    ]
    
}

extension ExperienceCheckoutViewModel {
    func fetchData() {
        guard let url = URL(string: "https://travelapi-sandbox.bookingbash.com/services/api/activities/2.0/review-details") else { return }
        let requestBody = ReviewDetailsRequestModel(
            uid: "688a6ef2d3545f348d1c720a",
            availability_id: "cd23671ff9d16aa56eddaf8ebac71aeba2407881c5c33f65cb3f20b30c274427",
            quote_id: "",
            enquiry_id: "", product_id: productIdG
        )
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Basic Qy1FWTNSM0c6OWRjOWMwOWRiMzdkYWRmYmQyNDAxYTljNjBmODY1MGY1YjZlMDFjYg==",
            "token": encryptedPayload
        ]
        
        NetworkManager.shared
            .post(url: url, body: requestBody, headers : headers) { (
                result: Result<ReviewTourDetailResponse,
                Error>
            ) in
                DispatchQueue.main.async { [self] in
                    switch result {
                    case .success(let response):
                        if let responseData = response.data {
                            print("=-=-=-=-=-==-=-=-=-=-=-=--=-=-///////////")
                            print(responseData)
                            print(responseData.info.title)
                            packageTitleG = responseData.info.title
                            addressG = responseData.info.city
                            priceSummaryPriceG = "\(responseData.priceSummary.strikeout?.totalAmount ?? 0)"
                            
                            print(responseData.priceSummary.strikeout?.totalAmount)
                            print(responseData.priceSummary.totalAmount)
                            var discountPrice = responseData.priceSummary.strikeout!.totalAmount  - responseData.priceSummary.totalAmount;
                            priceSummaryStrikeOutTotalG = "\(responseData.priceSummary.strikeout?.totalAmount ?? 0)"
                            priceSummaryDiscountG = "\(discountPrice)"
                            reviewResponse?.data = responseData
                            print("response for ReviewTourDetailResponse\(response)")
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
        }
    }
    
    
    
}
extension ExperienceCheckoutViewModel {
    
    func initBook() {
        guard let url = URL(string: "https://travelapi-sandbox.bookingbash.com/services/api/activities/2.0/initbook") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        let body: [String: Any] = [
            "travel_date": "2025-08-08",
            "title": "Mr",
            "product_id": productIdG,
            "first_name": firstName,
            "last_name": lastName,
            "email": customerEmail,
            "code": "91",
            "mobile": "8412921601",
            "travellers": 1,
            "total_adult": 1,
            "total_child": 0,
            "total_infant": 0,
            "total_senior": 0,
            "total_youth": 0,
          
            "option_id": "6890926fa47a497f767185bb",
            "currency": "INR",
            "coupon_code": "JulyOffer",
            "tour_code": "TG1",
            "tour_time": "",
            "applied_bounz": 0,
            "os_type": "Linux x86_64",
            "device_type": "desktop",
            "special_request": "",
            "pg_mode": "pg",
            "local_taxes_fee": 0,
            "quotation_id": "",
            "my_earning": [
                "agent_markup": 0,
                "totalfare": 593,
                "type": "markdown"
            ],
            "site_id": "68b585760e65320801973737",
            "display_markup": [:],
            "gst_dtl": [
                "addr": "",
                "org_name": "",
                "email": "",
                "gst_no": "",
                "contact_no": "",
                "isd_code": ""
            ],
            "pickup_obj": [
                "name": ""
            ],
            "traveller_details": [
                [
                    "title": "Mr",
                    "show_title": false,
                    "first_name": "",
                    "last_name": "",
                    "dob": "",
                    "height": "",
                    "passport_exp": "",
                    "passport_nationality": "",
                    "passport_no": "",
                    "weight": "",
                    "weight_unit": "kg",
                    "height_unit": "ft",
                    "age_band": "ADULT",
                    "passport_nationality_name": ""
                ]
            ],
            "language": [:],
            "destination_id": "12633",
            "pax_details": [
                [
                    "type": "ADULT",
                    "count": 1
                ]
            ],
            "supplier_code": "viator"
        ]
        print(body)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic Qy1FWTNSM0c6OWRjOWMwOWRiMzdkYWRmYmQyNDAxYTljNjBmODY1MGY1YjZlMDFjYg==",
                         forHTTPHeaderField: "Authorization")
        request.setValue(encryptedPayload, forHTTPHeaderField: "token")
        
        print(request)
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            self.errorMessage = "Failed to encode body"
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                guard let data = data else {
                    self.errorMessage = "No response data"
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        print("Full JSON Response: \(json)")
                  
                        if let dataDict = json["data"] as? [String: Any],
                           let orderNo = dataDict["order_no"] as? String {
                            print(orderNo)
                            self.orderNo = orderNo
                            // Navigate to payment page only after we have the order ID
                            self.shouldNavigateToPayment = true
                        } else {
                            self.errorMessage = "Invalid response format: \(json)"
                        }
                    }
                } catch {
                    self.errorMessage = "Failed to parse JSON"
                }
            }
        }.resume()
    }
}
