//
//  MobileCode.swift
//  VisaActivity
//
//  
//
import Foundation

struct MobileCode: Identifiable {
    let id = UUID()
    let name: String
    let maxCharLimit: Int
    let countryCode: Int
    let dialCode: String
    let image: String
}
