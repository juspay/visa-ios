//
//  TravellerBookingQuestionModel.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 22/01/26.
//

import Foundation
import UIKit

struct TravellerBookingQuestionModel: Codable {
    let id: String
    let language: String?

    // Backend typing
    let type: String?
    let typeName: String?

    // UI / description
    let group: String?
    let label: String?
    let description: String?
    let hint: String?

    // Validation
    let travellerBookingQuestionRequired: String?
    let formatRegex: String?

    // Constraints
    let maxLength: Int?
    let minLength: Int?
    let maxNumber: Int?
    let minNumber: Int?

    // Options
    let allowedAnswers: [String]?
    let items: [Item]?
    let units: [String]?

    // Validity
    let validFrom: String?
    let validTo: String?

    // Pricing / meta
    let addOn: Bool?
    let price: Double?

    // Pax-related
    let paxID: String?
    let paxType: String?

    enum CodingKeys: String, CodingKey {
        case id
        case language
        case type
        case typeName = "type_name"
        case group
        case label
        case description
        case hint
        case travellerBookingQuestionRequired = "required"
        case formatRegex
        case paxID = "paxId"
        case paxType = "pax_type"
        case maxLength = "max_length"
        case minLength = "min_length"
        case maxNumber = "max_number"
        case minNumber = "min_number"
        case allowedAnswers
        case items
        case units
        case validFrom
        case validTo
        case addOn
        case price
    }
}


extension TravellerBookingQuestionModel {
    var resolvedFormFieldType: FormFieldType {
        switch type {
        case "1", "2":
            return .dropdown
        case "3", "14", "4", "9":
            return .input
        case "6":
            return .dateField
        case "10":
            return .timeField
        case "7", "8":
            return .documentUpload
        case "13":
            return .phone
        case "15":
            return .dropdownWithInputField
        default:
            return .input
        }
    }
}

extension TravellerBookingQuestionModel {
    var isRequired: Bool {
        travellerBookingQuestionRequired == "MANDATORY"
    }
}

extension TravellerBookingQuestionModel {
    var effectiveRegex: String? {
        if let formatRegex, !formatRegex.isEmpty {
            return formatRegex
        }

        if let maxLength, maxLength > 0 {
            let min = minLength ?? 0
            return "^.{\(min),\(maxLength)}$"
        }

        if let maxNumber, maxNumber > 0 {
            let min = minNumber ?? 0
            return "^[0-9]{\(min),\(maxNumber)}$"
        }

        return nil
    }
}

extension TravellerBookingQuestionModel {
    var keyboardType: UIKeyboardType {
        switch type {
        case "3":
            return .numberPad
        case "13":
            return .phonePad
        case "14":
            return .asciiCapable
        default:
            return .default
        }
    }
}

//extension TravellerBookingQuestionModel {
//    var regexErrorMessage: String {
//        if let min = minLength, let max = maxLength, max > 0 {
//            return "\(label ?? "Value") must be between \(min) and \(max) characters"
//        }
//
//        if let min = minNumber, let max = maxNumber, max > 0 {
//            return "\(label ?? "Value") must be between \(min) and \(max) digits"
//        }
//
//        return "Invalid \(label ?? "value")"
//    }
//}
extension TravellerBookingQuestionModel {
    var regexErrorMessage: String {
        // Simplified based on your request
        return "Please enter a valid \(label?.lowercased() ?? "value")"
    }
}

extension TravellerBookingQuestionModel {
    func toFormField() -> FormField {
        
        // MARK: - Option Mapping Logic
        let displayOptions: [OptionItem]?
        if let modelItems = self.items, !modelItems.isEmpty {
            displayOptions = modelItems.compactMap { item -> OptionItem? in
                // Ensure we have a valid name to display
                guard let name = item.name, !name.isEmpty else { return nil }
                
                return OptionItem(
                    optionName: name,
                    reference: item.reference // Store the backend ID
                )
            }
        }
        // Priority 2: Check 'allowedAnswers' (Strings only, No Reference)
        else if let allowed = self.allowedAnswers, !allowed.isEmpty {
            
            displayOptions = allowed.map { answer in
                            OptionItem(optionName: answer, reference: nil)
                        }
        } else {
            displayOptions = nil
        }

        // MARK: - FormField Creation
        return FormField(
            id: self.id,
            type: self.resolvedFormFieldType,       // Uses your extension
            label: self.label ?? "",
            placeholder: self.label,                 // Uses 'hint' for placeholder
            isRequired: self.isRequired,            // Uses your extension
            
            regex: self.effectiveRegex,             // Uses your extension
            regexErrorMessage: self.regexErrorMessage, // Uses your extension
            keyboardType: self.keyboardType,        // Uses your extension
            
            value: "",                              // Default value empty
            titleValue: nil,                        // Default title nil
            fileBase64: nil,                          // Default base64 nil
            fileName: nil,                          // Default filename nil
            error: nil,                             // No error initially
            options: displayOptions,                // <--- The resolved names
            countryCode: nil,                        // Default nil
            group: self.group                     // Pass through group info
        )
    }
}

extension TravellerBookingQuestionModel {
    
    /// Finds the Backend ID (Reference) corresponding to the selected UI Value (Name).
    func getAnswerReference(forUserSelection selection: String) -> String {
        // 1. If this question uses 'items', find the item where name == selection
        if let modelItems = self.items, !modelItems.isEmpty {
            if let match = modelItems.first(where: { $0.name == selection }) {
                // Return the reference (ID), or fallback to selection if reference is missing
                return match.reference ?? selection
            }
        }
        
        // 2. For standard 'allowedAnswers' or text inputs, the value matches exactly
        return selection
    }
}
