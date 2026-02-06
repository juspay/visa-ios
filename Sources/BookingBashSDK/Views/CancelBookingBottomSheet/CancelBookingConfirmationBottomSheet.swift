////
////  CancelBookingConfirmationBottomSheet.swift
////  VisaActivity
////
////
//
//import SwiftUI
//
//struct CancelBookingConfirmationBottomSheet: View {
//    @Binding var isPresented: Bool
//    @ObservedObject var viewModel: ExperienceBookingConfirmationViewModel
//    var onCancelled: ((Bool) -> Void)? = nil
//
//    @State var buttonClicked: Bool = false
//
//    var body: some View {
//        BottomSheetView(isPresented: $isPresented) {
//            VStack(alignment: .leading, spacing: 20) {
//                Text(Constants.BookingStatusScreenConstants.cancelBookingTitle)
//                    .font(.custom(Constants.Font.openSansBold, size: 14))
//                    .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
//                SeparatorLine()
//                
//                HStack {
//                    Text(Constants.BookingStatusScreenConstants.totalAmount)
//                    Spacer()
//                    Text("\(viewModel.preCancelbookingResponse?.data?.currency ?? "AED") \(viewModel.preCancelbookingResponse?.data?.totalAmount?.commaSeparated() ?? "0.00")")
//                }
//                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
//                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
//                
//                HStack {
//                    Text(Constants.BookingStatusScreenConstants.deduction)
//                    Spacer()
//                    Text("\(viewModel.preCancelbookingResponse?.data?.currency ?? "AED") \(viewModel.preCancelbookingResponse?.data?.cancellationFee?.commaSeparated() ?? "0.00")")
//                }
//                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
//                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
//                
//                SeparatorLine()
//                
//                HStack {
//                    Text(Constants.BookingStatusScreenConstants.totalAmountToBeRefunded)
//                        .font(.custom(Constants.Font.openSansBold, size: 12))
//                    Spacer()
//                    Text("\(viewModel.preCancelbookingResponse?.data?.currency ?? "AED") \(viewModel.preCancelbookingResponse?.data?.refundAmount?.commaSeparated() ?? "0.00")")
//                        .font(.custom(Constants.Font.openSansBold, size: 12))
//                        .foregroundStyle(Color.black)
//                }
//                
//                VStack(alignment: .leading, spacing: 0) {
//                    Text(Constants.BookingStatusScreenConstants.refundAmount)
//                        .font(.custom(Constants.Font.openSansBold, size: 12))
//                        .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
//                    Text(Constants.BookingStatusScreenConstants.refundText)
//                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
//                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
//                }
//                .padding(4)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .background(Color(hex: Constants.HexColors.bgPremierWeak))
//            
//                Button(action: {
//                    buttonClicked = true
//                    cancelBooking()
//                }) {
//                    Group {
//                        if buttonClicked {
//                            ProgressView()
//                                .foregroundStyle(.white)
//                        } else {
//                            Text(Constants.BookingStatusScreenConstants.cancelNow)
//                                .font(.custom(Constants.Font.openSansBold, size: 12))
//                                .foregroundStyle(.white)
//                        }
//                    }
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 42)
//                        .background(Color(hex: Constants.HexColors.primary))
//                        .cornerRadius(4)
//                }
//            }
//            .padding(.top, 24)
//            .padding([.horizontal, .bottom], 16)
//        }
//    }
//
//    private func cancelBooking() {
//        guard let selectedReason = viewModel.selectedReason else { return }
//
//        viewModel.cancelBooking(reasonCode: selectedReason.code) { success in
//            onCancelled?(success)
//            isPresented = false
//        }
//    }
//}
