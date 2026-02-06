//
//  Components.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 22/01/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct InputField: View {
    @Binding var text: String
    let field: FormField

    var body: some View {
        FormFieldWrapper(
            label: field.label,
            isRequired: field.isRequired,
            error: field.error
        ) {
            TextField(field.placeholder ?? "", text: $text)
                .keyboardType(field.keyboardType)
                .font(.custom(Constants.Font.openSansRegular, size: 12))
                .autocapitalization(.none)
        }
    }
}

struct PhoneField: View {
    @Binding var phoneNumber: String
    @Binding var selectedCountryCode: String?
    @State private var selectedCountry : MobileCode?

    let field: FormField
    let countries: [MobileCode]

    var body: some View {
        FormFieldWrapper(
            label: field.label,
            isRequired: field.isRequired,
            error: field.error
        ) {
            HStack(spacing: 8) {
                Menu {
                    ForEach(countries) { country in
                        Button {
                            selectedCountry = country
                            selectedCountryCode = country.dialCode
                            phoneNumber = ""
                        } label: {
                            HStack {
                                Text(country.image) // 🇮🇳 emoji or asset name
                                Text(country.name)
                                    .font(.custom(Constants.Font.openSansRegular, size: 12))
                                Spacer()
                                Text(country.dialCode)
                                    .font(.custom(Constants.Font.openSansRegular, size: 12))
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text(selectedCountry?.image ?? "")
                                .font(.custom(Constants.Font.openSansRegular, size: 12))
                        Text(selectedCountry?.dialCode ?? "")
                                .font(.custom(Constants.Font.openSansRegular, size: 12))
                        Image(systemName: "chevron.down")
                    }
                }

                Divider()

                // 📱 Phone Input
                TextField(
                    field.placeholder ?? "",
                    text: Binding(
                        get: { phoneNumber },
                        set: { newValue in
                            let filtered = newValue.filter { $0.isNumber }
                            phoneNumber = String(
                                filtered.prefix(selectedCountry?.maxCharLimit ?? 10)
                            )
                        }
                    )
                )
                .keyboardType(.numberPad)
            }
        }
    }
}

struct DateField: View {
    @Binding var date: Date?
    let field: FormField
    let min: Date? = nil
    let max: Date? = nil
    
    // State to control navigation
    @State private var navigateToDatePicker = false

    var body: some View {
        VStack {
            FormFieldWrapper(
                label: field.label,
                isRequired: field.isRequired,
                error: field.error
            ) {
                // 1. Tappable Area
                Button {
                    navigateToDatePicker = true
                } label: {
                    HStack {
                        Text(formattedDateString)
                            .foregroundColor(date == nil ? .gray : .primary)
                            .font(.custom(Constants.Font.openSansRegular, size: 12))
                        
                        Spacer()
                        
                        Image(systemName: "calendar")
                            .foregroundColor(Color(hex: Constants.HexColors.primary))
                    }
                    .padding(.vertical, 4)
                    .contentShape(Rectangle())
                }
            }
            .background(
                NavigationLink(
                    isActive: $navigateToDatePicker,
                    destination: {
                        DatePickerView(
                            date: $date,
                            min: min,
                            max: max,
                            label: field.label,
                            onContinue: {
//                                navigateToDatePicker = false
                            }
                        )
                        .navigationBarBackButtonHidden(true)
                    },
                    label: { EmptyView() }
                )
                .hidden()
            )
        }
    }
    
    private var formattedDateString: String {
       guard let d = date else { return "dd/mm/yyyy" }
       let formatter = DateFormatter()
       // MM = Month, mm = minutes. Make sure to use capital MM.
       formatter.dateFormat = "YYYY-MM-DD"
       return formatter.string(from: d)
   }
}

struct DropDownWithInputField: View {
    @Binding var selection: String
    @Binding var referance: String?
    let field: FormField
    @State private var showInputField: Bool = false
    @State private var selectedOption: OptionItem = OptionItem(optionName: "", reference: "")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 2) {
                Text(field.label)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundColor(Color(hex: Constants.HexColors.neutral))
                if field.isRequired { Text("*").foregroundColor(.red) }
            }

            ZStack {
                // 1. The Visual Layer (Static UI)
                // This ensures the look never changes when clicked
                HStack {
                    Text((selectedOption.optionName.isEmpty ? (field.placeholder ?? "Select") : selectedOption.optionName))
                        .foregroundColor(selectedOption.optionName.isEmpty ? .gray : .primary)
                        .font(.custom(Constants.Font.openSansRegular, size: 12))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: Constants.HexColors.neutral))
                }
                
                // 2. The Interaction Layer (Invisible Menu Trigger)
                // Spans the entire area on top of the visual layer
                Menu {
                    ForEach(field.options ?? [], id: \.reference) { option in
                        Button {
                            selectedOption.optionName = option.optionName
                            selection = option.optionName
                            referance = option.reference
                        } label: {
                            Text(option.optionName)
                        }
                    }
                    Button {
                        showInputField = true
                        selectedOption.optionName = "Other"
                        referance = "other"
                    } label: {
                        Text("Other")
                    }
                    
                } label: {
                    // Invisible, tappable layer
                    Color.white.opacity(0.001)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                }
                
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(field.error == nil ? .gray.opacity(0.4) : .red))
            
            if showInputField {
                TextField(field.placeholder ?? "", text: $selection)
                    .keyboardType(field.keyboardType)
                    .font(.custom(Constants.Font.openSansRegular, size: 12))
                    .autocapitalization(.none)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(field.error == nil ? .gray.opacity(0.4) : .red))
            }
    
            if let error = field.error {
                Text(error)
                    .font(.custom(Constants.Font.openSansRegular, size: 10))
                    .foregroundStyle(Color(hex: Constants.HexColors.error))
            }
        }
    }
}

struct DropdownField: View {
    @Binding var selection: String
    @Binding var referance: String?
    let field: FormField

    var body: some View {
        FormFieldWrapper(
            label: field.label,
            isRequired: field.isRequired,
            error: field.error
        ) {
            ZStack {
                // 1. The Visual Layer (Static UI)
                // This ensures the look never changes when clicked
                HStack {
                    Text(selection.isEmpty ? (field.placeholder ?? "Select") : selection)
                        .foregroundColor(selection.isEmpty ? .gray : .primary)
                        .font(.custom(Constants.Font.openSansRegular, size: 12))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: Constants.HexColors.neutral))
                }
                
                // 2. The Interaction Layer (Invisible Menu Trigger)
                // Spans the entire area on top of the visual layer
                Menu {
                    ForEach(field.options ?? [], id: \.self) { option in
                        Button {
                            selection = option.optionName
                            referance = option.reference
                        } label: {
                            Text(option.optionName)
                        }
                    }
                } label: {
                    // Invisible, tappable layer
                    Color.white.opacity(0.001)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                }
            }
        }
    }
}

struct MultilineField: View {
    @Binding var text: String
    let field: FormField

    var body: some View {
        FormFieldWrapper(
            label: field.label,
            isRequired: field.isRequired,
            error: field.error
        ) {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .frame(height: 80)
                    .font(.custom(Constants.Font.openSansRegular, size: 12))
                
                if text.isEmpty {
                    Text("Type here...")
                        .font(.custom(Constants.Font.openSansRegular, size: 12))
                        .foregroundColor(Color(hex: Constants.HexColors.neutral))
                        .padding(.top, 3)
                }
            }
        }
    }
}

struct DocumentUploadField: View {
    @Binding var fileBase64: String?
    @Binding var fileName: String?
    let field: FormField

    @State private var showPicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    // UPDATE: 5 MB Limit
    // 5 * 1024 * 1024 = 5,242,880 bytes
    private let maxFileSize = 5 * 1024 * 1024

    var body: some View {
        VStack {
            FormFieldWrapper(
                label: field.label,
                isRequired: field.isRequired,
                error: field.error,
                // Assuming you updated FormFieldWrapper to accept this param based on previous context
                // If not, remove 'needUploadNote' and put the text manually in the body
                needUploadNote: true
            ) {
                Button {
                    showPicker = true
                } label: {
                    HStack {
                        // Display FileName if it exists, otherwise placeholder
                        Text(fileName ?? "Select file & upload")
                            .foregroundColor(fileName == nil ? .gray : .primary)
                            .font(.custom(Constants.Font.openSansRegular, size: 12))
                            .lineLimit(1)
                            .truncationMode(.middle)
                        
                        Spacer()
                        
                        if let arrow = ImageLoader.bundleImage(named: Constants.Icons.upload) {
                            arrow
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color(hex: Constants.HexColors.primary))
                        } else {
                            // Fallback icon if ImageLoader fails
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .frame(width: 16, height: 20)
                                .foregroundColor(Color(hex: Constants.HexColors.primary))
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showPicker) {
            DocumentPicker(
                supportedTypes: [.pdf, .image] // Removed .data to be more specific, add back if needed
            ) { url in
                handlePickedFile(url)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("File too large"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func handlePickedFile(_ url: URL) {
       let canAccess = url.startAccessingSecurityScopedResource()
       defer { if canAccess { url.stopAccessingSecurityScopedResource() } }

       do {
           // 1. Check Size
           let resources = try url.resourceValues(forKeys: [.fileSizeKey])
           if let fileSize = resources.fileSize, fileSize > maxFileSize {
               alertMessage = "The selected file exceeds the 5MB limit. Please choose a smaller file."
               showAlert = true
               return
           }

           // 2. Read Raw Data
           let data = try Data(contentsOf: url)
           
           // 3. ✅ Convert to Base64 String
           let base64String = data.base64EncodedString()

           // 4. ✅ Assign directly to the String binding
           self.fileBase64 = base64String
           self.fileName = url.lastPathComponent
           print("\n\n fileBase64:--->", fileBase64)

       } catch {
           print("Failed to read file:", error)
           alertMessage = "Failed to read the file. Please try again."
           showAlert = true
       }
   }
}

struct NameWithTitleField: View {
    @Binding var name: String
    @Binding var title: String?

    let field: FormField
    let titles = ["Mr", "Ms", "Mrs"]

    var body: some View {
        FormFieldWrapper(
            label: field.label,
            isRequired: field.isRequired,
            error: field.error
        ) {
            HStack(spacing: 8) {

                Menu {
                    ForEach(titles, id: \.self) { option in
                        Button(option) {
                            title = option
                        }
                    }
                } label: {
                    Text(title ?? "Title")
                        .foregroundColor(title == nil ? .gray : .primary)
                        .font(.custom(Constants.Font.openSansRegular, size: 12))
                }

                Divider()

                TextField(field.placeholder ?? "", text: $name)
                    .font(.custom(Constants.Font.openSansRegular, size: 12))
            }
        }
    }
}

struct TimeField: View {
    @Binding var timeString: String
    let field: FormField
    
    // 👇 Access the trigger from the parent
    @Environment(\.showTimePicker) var pickerAction
    
    var body: some View {
        VStack {
            FormFieldWrapper(
                label: field.label,
                isRequired: field.isRequired,
                error: field.error
            ) {
                Button {
                    // 👇 Pass the binding of THIS field up to the root view
                    pickerAction.show($timeString)
                } label: {
                    HStack {
                        Text(timeString.isEmpty ? (field.placeholder ?? "Select Time") : timeString)
                            .foregroundColor(timeString.isEmpty ? .gray : .primary)
                            .font(.custom(Constants.Font.openSansRegular, size: 12))
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: Constants.HexColors.neutral))
                    }
                }
            }
        }
    }
}
