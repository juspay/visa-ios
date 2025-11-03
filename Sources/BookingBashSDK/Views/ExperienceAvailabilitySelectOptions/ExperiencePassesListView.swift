import Foundation
import SwiftUI

struct ExperiencePassesListView: View {
    @ObservedObject var viewModel: ExperienceAvailabilitySelectOptionsViewModel
    @ObservedObject var experienceDetailViewModel: ExperienceDetailViewModel
    
    var model: ExperienceDetailModel
    let productCode: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if viewModel.isLoading {
                LoaderView(text: "Loading Packages...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            } else {
                Text("\(viewModel.packages.count) \(Constants.AvailabilityScreenConstants.optionsAvailable)")
                    .font(.custom(Constants.Font.openSansBold, size: 14))
                    .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                
                if viewModel.packages.isEmpty {
                    VStack(spacing: 12) {
                        if let noResultImage = ImageLoader.bundleImage(named: Constants.Icons.searchNoResult) {
                            noResultImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: 124, height: 124)
                                .padding(.top, 40)
                        }
                        
                        Text(Constants.AvailabilityScreenConstants.noPackagesAvailable)
                            .font(.custom(Constants.Font.openSansRegular, size: 14))
                            .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ForEach(viewModel.packages) { package in
                        ExperiencePassesCardView(
                            package: package,
                            model: model,
                            viewModel: viewModel,
                            experienceDetailViewModel: experienceDetailViewModel,
                            productCode: productCode,
                            currency: nil,
                            subActivityCode: package.subActivityCode ?? "",
                            uid: viewModel.response?.data?.uid ?? "",
                            availabilityKey: findAvailabilityKey(for: package)
                        )
                    }
                }
            }
        }
        .padding()
        .animation(.easeInOut, value: viewModel.isLoading)
    }
    
    private func findAvailabilityKey(for package: Package) -> String {
        if let availabilityItem = viewModel.response?.data?.result?.first(where: { $0.subActivityName == package.title }) {
            return availabilityItem.availabilityId
        }
        return ""
    }
}
