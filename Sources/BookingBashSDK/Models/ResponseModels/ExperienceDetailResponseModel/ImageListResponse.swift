//
//  ImageListResponse.swift
//  VisaActivity
//

import Foundation

// MARK: - Image List Response Models
struct ImageListResponse: Codable {
    let status: Bool
    let statusCode: Int
    let data: ImageListData?
    
    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status_code"
        case data
    }
}

struct ImageListData: Codable {
    let count: Int
    let result: [ImageResult]
}

struct ImageResult: Codable {
    let caption: String
    let isCover: Bool
    let variant: [ImageVariant]
    
    enum CodingKeys: String, CodingKey {
        case caption
        case isCover = "is_cover"
        case variant
    }
}

struct ImageVariant: Codable {
    let height: Int
    let width: Int
    let url: String
}
