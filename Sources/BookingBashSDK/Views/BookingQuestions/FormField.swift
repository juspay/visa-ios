//
//  FormField.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 22/01/26.
//

import SwiftUI

enum FormFieldType {
    case input          // string, number, flight no
    case dropdown       // list
    case multiSelect    // list multiple
    case dateField           // date
    case timeField           // time
    case phone          // string: phone
    case address        // address
    case documentUpload // file / image
    case nameWithTitle
    case dropdownWithInputField
}

struct FormField: Identifiable {
    let id: String
    let type: FormFieldType
    let label: String
    let placeholder: String?
    let isRequired: Bool

    let regex: String?
    let regexErrorMessage: String
    let keyboardType: UIKeyboardType

    var value: String
    var titleValue: String?
    var fileBase64: String? 
//    var fileData: Data?
    var fileName: String?
    var error: String?
    var options: [OptionItem]?
    var countryCode: String?
    var reference: String? = nil
    var group: String? = nil
}

struct OptionItem: Hashable {
    var optionName: String
    var reference: String? = nil
}


extension FormField {

    /// Final value to be sent to backend
    var payloadValue: String {
        switch type {
        case .nameWithTitle:
            return [titleValue, value]
                .compactMap { $0 }
                .joined(separator: " ")

        default:
            return value
        }
    }
}

struct FormFieldWrapper<Content: View>: View {
    let label: String
    let isRequired: Bool
    let error: String?
    var needUploadNote: Bool = false
    let content: Content

    init(
        label: String,
        isRequired: Bool,
        error: String?,
        needUploadNote: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.label = label
        self.isRequired = isRequired
        self.error = error
        self.needUploadNote = needUploadNote
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 2) {
                Text(label)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundColor(Color(hex: Constants.HexColors.neutral))
                if isRequired { Text("*").foregroundColor(.red) }
            }

            content
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(error == nil ? .gray.opacity(0.4) : .red))

            if let error {
                Text(error)
                    .font(.custom(Constants.Font.openSansRegular, size: 10))
                    .foregroundStyle(Color(hex: Constants.HexColors.error))
            }
            
            if needUploadNote {
                HStack {
                    Text("Supported file format: JPG, PNG,PDF")
                        .font(.custom(Constants.Font.openSansSemiBold, size: 10))
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    Spacer()
                    Text("Max file size: 5MB")
                        .font(.custom(Constants.Font.openSansSemiBold, size: 10))
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                }
            }
        }
    }
}

#Preview {
//    FormField()
}
