//
//  CurrencyListModel.swift
//  VisaActivity

import Foundation

struct CurrencyListResponseModel: Codable {
    let status: Bool?
    let message: String?
    let currencyListData: CurrencyListDataModel?
    
    enum CodingKeys: String, CodingKey {
        case status, message
        case currencyListData = "data"
    }
}

// MARK: - DataClass
struct CurrencyListDataModel: Codable {
    let popular, other: [CurrencyDataModel]?
    let totalCount: Int?
    let categories: Categories?

    enum CodingKeys: String, CodingKey {
        case popular
        case other
        case totalCount = "total_count"
        case categories
    }
}

// MARK: - Categories
struct Categories: Codable {
    let popularCount, otherCount: Int?

    enum CodingKeys: String, CodingKey {
        case popularCount = "popular_count"
        case otherCount = "other_count"
    }
}

// MARK: - Other
struct CurrencyDataModel: Codable {
    let name, code: String?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case name
        case code
        case status
    }
}
