//
//  TimePickerBottomsheet.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 27/01/26.
//

import SwiftUI

struct TimePickerAction {
    let show: (Binding<String>) -> Void
}

struct TimePickerActionKey: EnvironmentKey {
    static let defaultValue: TimePickerAction = TimePickerAction { _ in }
}

extension EnvironmentValues {
    var showTimePicker: TimePickerAction {
        get { self[TimePickerActionKey.self] }
        set { self[TimePickerActionKey.self] = newValue }
    }
}

struct TimePickerBottomsheet: View {
    @Binding var isPresented: Bool
    @Binding var selectedTime: String // Format: "HH:mm"

    // Internal state for the pickers
    @State private var selectedHour: Int = 12
    @State private var selectedMinute: Int = 0

    var body: some View {
        BottomSheetView(isPresented: $isPresented) {
            VStack(spacing: 0) {
                
                // Header
                Text("Select Time")
                    .font(.custom(Constants.Font.openSansBold, size: 16))
                    .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                    .padding(.top, 16)
                    .padding(.bottom, 24)

                HStack(spacing: 16) {
                    
                    // MARK: - Hour Dropdown
                    timeDropdown(
                        title: "Hour",
                        value: selectedHour,
                        range: 0..<24
                    ) { newHour in
                        selectedHour = newHour
                    }
                    
                    // MARK: - Minute Dropdown
                    timeDropdown(
                        title: "Minutes",
                        value: selectedMinute,
                        range: 0..<60
                    ) { newMinute in
                        selectedMinute = newMinute
                    }
                }
                .padding(.horizontal, 16)

                // Confirm Button
                Button {
                    // Save as HH:mm
                    selectedTime = String(format: "%02d:%02d", selectedHour, selectedMinute)
                    isPresented = false
                } label: {
                    Text("OK")
                        .font(.custom(Constants.Font.openSansBold, size: 14))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color(hex: Constants.HexColors.primary))
                        .cornerRadius(24) // Pill shape like in screenshot
                }
                .padding(.horizontal, 16)
                .padding(.top, 32)
                .padding(.bottom, 16)
            }
            // Ensure height accommodates the content
            .padding(.bottom, 20)
            .onAppear {
                parseCurrentTime()
            }
        }
    }
    
    // MARK: - Helper View for Dropdowns
    @ViewBuilder
    func timeDropdown(title: String, value: Int, range: Range<Int>, onSelect: @escaping (Int) -> Void) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom(Constants.Font.openSansRegular, size: 12))
                .foregroundColor(.gray)
            
            Menu {
                ForEach(range, id: \.self) { num in
                    Button {
                        onSelect(num)
                    } label: {
                        // Display formatting in the dropdown list
                        Text(String(format: "%02d", num))
                    }
                }
            } label: {
                HStack {
                    // Selected Value Display
                    Text(String(format: "%02d", value))
                        .font(.custom(Constants.Font.openSansSemiBold, size: 16))
                        .foregroundColor(Color(hex: Constants.HexColors.blackStrong))
                    
                    Spacer()
                    
                    if let arrow = ImageLoader.bundleImage(named: Constants.Icons.arrowDown) {
                        arrow
                            .resizable()
                            .frame(width: 14, height: 14) // Adjusted size to match screenshot
                            .foregroundColor(Color(hex: Constants.HexColors.neutral))
                    } else {
                        Image(systemName: "chevron.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: Constants.HexColors.neutralWeak), lineWidth: 1)
                )
            }
            // Ensures the menu label takes full available width
            .frame(maxWidth: .infinity)
        }
    }

    // Helper: Initialize pickers if a time is already selected (e.g., "14:30")
    private func parseCurrentTime() {
        // If string is empty, default to current time
        if selectedTime.isEmpty {
            let now = Date()
            let calendar = Calendar.current
            selectedHour = calendar.component(.hour, from: now)
            selectedMinute = calendar.component(.minute, from: now)
            return
        }
        
        let components = selectedTime.split(separator: ":")
        if components.count == 2,
           let h = Int(components[0]),
           let m = Int(components[1]) {
            selectedHour = h
            selectedMinute = m
        }
    }
}

#Preview {
//    TimePickerBottomsheet()
}
