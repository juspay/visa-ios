//
//  SSOLoginRequest.swift
//  VisaActivity
//
//  Created by Praveen on 16/10/25.
//

import Foundation

// MARK: - SSO Login Request Model
struct SSOLoginRequestModel: Codable {
    let token: String
    
    init(token: String) {
        self.token = token
    }
}
