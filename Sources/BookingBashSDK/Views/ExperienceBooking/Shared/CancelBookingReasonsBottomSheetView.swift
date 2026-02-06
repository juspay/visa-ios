import Foundation
import SwiftUI

struct CancelBookingReasonsBottomSheetView: View {
    @ObservedObject var viewModel: ExperienceBookingConfirmationViewModel
    @Binding var isPresented: Bool
    var onNextClicked: ((CancellationReason?) -> Void)? = nil

    var body: some View {
        BottomSheetView(isPresented: $isPresented, dismissOnbackgroundClick: true) {
            VStack(alignment: .leading, spacing: 16) {
                if viewModel.reasons.isEmpty {
                    Text(Constants.BookingStatusScreenConstants.noCancellationReasonsAvailable)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                        .padding(.vertical, 8)
                } else {
                    VStack(alignment: .leading, spacing: 24) {
                        Text(Constants.BookingStatusScreenConstants.selectCancellationReason)
                            .font(.custom(Constants.Font.openSansBold, size: 12))
                            .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                        
                        SeparatorLine()
                        
                        ForEach(viewModel.reasons, id: \.code) { reason in
                            Button(action: {
                                viewModel.selectedReason = reason
                            }) {
                                HStack {
                                    Image(systemName: viewModel.selectedReason?.code == reason.code ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(viewModel.selectedReason?.code == reason.code ?
                                                         Color(hex: Constants.HexColors.primary) :
                                                         Color(hex: Constants.HexColors.neutral))
                                    
                                    Text(reason.title)
                                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                        .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                                    
                                    Spacer()
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding(.vertical, 8)
                }

                // MARK: - Cancel Button
                Button(action: {
                    isPresented = false
                    onNextClicked?(viewModel.selectedReason)
                }) {
                    Text(Constants.BookingStatusScreenConstants.next)
                        .font(.custom(Constants.Font.openSansBold, size: 12))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .background(Color(hex: Constants.HexColors.primary))
                        .cornerRadius(4)
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 16)
        }
    }
}
