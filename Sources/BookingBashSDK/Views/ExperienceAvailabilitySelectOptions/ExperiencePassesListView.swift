import Foundation
import SwiftUI

struct ExperiencePassesListView: View {
    @ObservedObject var viewModel: ExperienceAvailabilitySelectOptionsViewModel
    @ObservedObject var experienceDetailViewModel: ExperienceDetailViewModel
    @Binding var showPriceChangeSheet: Bool
    var model: ExperienceDetailModel
    let productCode: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if viewModel.isLoading {
                LoaderView(text: "Loading Packages...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            } else {
                if viewModel.packages.isEmpty {
                    VStack(spacing: 12) {
                        ErrorMessageView(errorMessage: .noMatchFound)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 60)
                } else {
                    Text("\(viewModel.packages.count) \(Constants.AvailabilityScreenConstants.optionsAvailable)")
                        .font(.custom(Constants.Font.openSansBold, size: 14))
                        .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))

                    ForEach(viewModel.packages) { package in
                        ExperiencePassesCardView(
                            package: package,
                            model: model, showPriceChangeSheet: $showPriceChangeSheet,
                            viewModel: viewModel,
                            experienceDetailViewModel: experienceDetailViewModel,
                            productCode: productCode,
                            currency: currencyGlobal,
                            subActivityCode: package.subActivityCode ?? "",
                            uid: viewModel.response?.data?.uid ?? "",
                            availabilityKey: viewModel.findAvailabilityKey(for: package)
                        )
                    }
                }
            }
        }
        .padding()
        .animation(.easeInOut, value: viewModel.isLoading)
    }
}
