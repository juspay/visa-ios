//
//  FormFieldRenderer.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 22/01/26.
//

import SwiftUI

struct FormFieldRenderer: View {
    @Binding var field: FormField

    // Phone-specific dependencies
    let countries: [MobileCode] = MobileCodeData.allCodes

    var body: some View {
        switch field.type {
        case .input:
            InputField(
                text: $field.value,
                field: field
            )

        // Phone
        case .phone:
            PhoneField(
                phoneNumber: $field.value,
                selectedCountryCode: $field.countryCode,
                field: field,
                countries: countries
            )

        // Dropdown
        case .dropdown:
            DropdownField(
                selection: $field.value, referance: $field.reference,
                field: field
            )

        // Date
        case .dateField:
            let dateFormatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.calendar = Calendar(identifier: .iso8601)
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    formatter.timeZone = TimeZone(secondsFromGMT: 0)
                    formatter.dateFormat = "yyyy-MM-dd"
                    return formatter
                }()
            DateField(
                date: Binding(
                    get: {
                        dateFormatter.date(from: field.value)
                    },
                    set: {
                        field.value = $0.map {
                            dateFormatter.string(from: $0)
                        } ?? ""
                    }
                ),
                field: field)

        // Multiline
        case .multiSelect:
            MultilineField(
                text: $field.value,
                field: field
            )

        // Document upload
        case .documentUpload:
            DocumentUploadField(
                fileBase64: Binding(
                    get: { field.fileBase64 },
                    set: { field.fileBase64 = $0 }
                ),
                fileName: Binding(
                    get: { field.fileName },
                    set: { field.fileName = $0 }
                ),
                field: field
            )
        
        case .nameWithTitle:
            NameWithTitleField(
                name: $field.value,
                title: Binding(
                    get: { field.titleValue },
                    set: { field.titleValue = $0 }
                ),
                field: field
            )

        case .timeField:
            TimeField(timeString: $field.value, field: field)

        case .address:
            InputField(
                text: $field.value,
                field: field
            )
        
        case .dropdownWithInputField:
            DropDownWithInputField(selection: $field.value, referance: $field.reference, field: field)
        }
    }
}
