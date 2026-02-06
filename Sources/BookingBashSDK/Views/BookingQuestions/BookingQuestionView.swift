//
//  BookingQuestionView.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 22/01/26.
//

import SwiftUI

struct BookingQuestionView: View {
    @ObservedObject var viewModel: ExperienceCheckoutViewModel
    var onFormSubmit: (() -> Void)
    @Environment(\.dismiss) var dismiss
    // MARK: - Time Picker State
      @State private var showTimePickerSheet = false
      @State private var activeTimeBinding: Binding<String> = .constant("")

    var body: some View {
        ThemeTemplateView(
            header: { headerSection },
            content: { contentSection }
        )
    }

    var headerSection: some View {
        Text("Booking Questions")
            .font(.custom(Constants.Font.openSansBold, size: 14))
            .foregroundStyle(Color.white)
    }

    var contentSection: some View {
        ZStack {
            VStack {
                VStack {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            // MARK: - SECTION 1: Per Booking Questions
                            if !viewModel.bookingFields.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Booking Details")
                                        .font(.custom(Constants.Font.openSansBold, size: 16))
                                        .foregroundColor(.primary)
                                    
                                    ForEach($viewModel.bookingFields) { $field in
                                        FormFieldRenderer(field: $field)
                                            .onChange(of: field.value) { _ in
                                                // Re-check global validity when booking fields change
                                                viewModel.checkAllFormsValid()
                                            }
                                    }
                                }
                            }

                            // MARK: - SECTION 2: Per Traveller Questions
                            if !viewModel.travellers.isEmpty {
                                // Use Array(enumerated) to get the index
                                ForEach(Array(viewModel.travellers.enumerated()), id: \.element.id) { index, traveller in
                                    
                                    // 🔒 Lock Logic:
                                    // Card is ENABLED if:
                                    // 1. It's the first card (index 0) OR
                                    // 2. The PREVIOUS card (index - 1) is completely valid
                                    let isPreviousValid = (index == 0) || viewModel.travellers[index - 1].isValid
                                    let isDisabled = !isPreviousValid
                                    
                                    // We need a binding to the element in the array
                                    let binding = $viewModel.travellers[index]
                                    
                                    VStack(alignment: .leading, spacing: 16) {
                                        BookingQuestionsCardView(
                                            travellerData: binding,
                                            isDisabled: isDisabled,
                                            validateForm: {
                                                viewModel.validateTravellerForm(travellerId: traveller.id)
                                            }
                                        )
                                    }
                                }
                            }
                        }
                        .padding(16)
                    }
                    .frame(maxHeight: .infinity)
                }
                
                Spacer()
                
                // MARK: - Global Save Button
                // Only visible when ALL forms are valid
                if viewModel.areAllFormsValid {
                    Button(action: {
                        onFormSubmit()
                        dismiss()
                    }) {
                        Text("Continue")
                            .font(.custom(Constants.Font.openSansBold, size: 12))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 42)
                            .background(Color(hex: Constants.HexColors.primary))
                            .cornerRadius(4)
                            .padding(.bottom)
                    }
                    .buttonStyle(.plain)
                    .padding()
    //                .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .environment(\.showTimePicker, TimePickerAction(show: { binding in
                           self.activeTimeBinding = binding
                           self.showTimePickerSheet = true
                       }))
            
            // 2. Custom Full Screen Overlay
            if showTimePickerSheet {
                // Dimmed Background
//                Color.black.opacity(0.4)
//                    .edgesIgnoringSafeArea(.all)
//                    .onTapGesture { showTimePickerSheet = false }
//                    .zIndex(100)
                
                // The Bottom Sheet
                TimePickerBottomsheet(
                    isPresented: $showTimePickerSheet,
                    selectedTime: activeTimeBinding
                )
                .zIndex(101)
                .transition(.move(edge: .bottom))
            }
        }
        .dismissKeyboardOnTap()
    }
}

struct BookingQuestionsCardView: View {
    @Binding var travellerData: TravellerInstance
    var isDisabled: Bool
    var validateForm: (() -> Void)
    
    @State private var isCollapsable: Bool = false
    
    var body: some View {
        VStack {
            // Header Row
            VStack(alignment: .leading) {
                HStack(spacing: 2) {
                    if travellerData.isValid {
                        if let check = ImageLoader.bundleImage(named: Constants.Icons.greenCheckFill) {
                            check.resizable().frame(width: 20, height: 20)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text(travellerData.displayTitle)
                            .font(.custom(Constants.Font.openSansBold, size: 13))
                            .foregroundColor(isDisabled ? .gray : .primary)
                    }
                    
                    Spacer()
                    
                    if let arrow = ImageLoader.bundleImage(named: Constants.Icons.arrowDown) {
                        arrow
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(hex: isDisabled ? Constants.HexColors.greenShade : Constants.HexColors.primary))
                            .rotationEffect(.degrees(isCollapsable ? 180 : 0))
                    }
                }
                
                if travellerData.isValid, !isCollapsable {
                    Text("Details Completed")
                        .font(.custom(Constants.Font.openSansBold, size: 13))
                        .foregroundColor(Color(hex: Constants.HexColors.greenShade))
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if !isDisabled {
                    withAnimation { isCollapsable.toggle() }
                }
            }

            // Form Content
            if isCollapsable && !isDisabled {                
                ForEach($travellerData.fields) { $field in
                    FormFieldRenderer(field: $field)
                }
                
                Button(action: {
                    withAnimation {
                        validateForm()
                        // Optional: Auto-collapse on save if valid
                        if travellerData.isValid {
                            isCollapsable = false
                        }
                    }
                }) {
                    Text("Save")
                        .font(.custom(Constants.Font.openSansBold, size: 12))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .background(Color(hex: Constants.HexColors.primary))
                        .cornerRadius(4)
                }
                .buttonStyle(.plain)
                .padding(.top, 8)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    travellerData.isValid
                    ? Color(hex: Constants.HexColors.surfaceWeakest)
                    : Color.clear
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    travellerData.isValid
                    ? Color.green
                    : Color(hex: Constants.HexColors.neutralWeak),
                    lineWidth: 1
                )
        )
        // Dim the whole card if disabled
        .opacity(isDisabled ? 0.6 : 1.0)
        // Auto-expand logic: If this card just got unlocked (became enabled) and isn't done, open it
        .onChange(of: isDisabled) { disabled in
            if !disabled && !travellerData.isValid {
                withAnimation { isCollapsable = true }
            }
        }
        // Ensure first card is open by default
        .onAppear {
            if !isDisabled && !travellerData.isValid {
                isCollapsable = true
            }
        }
    }
}

#Preview {
//    BookingQuestionView()
}

