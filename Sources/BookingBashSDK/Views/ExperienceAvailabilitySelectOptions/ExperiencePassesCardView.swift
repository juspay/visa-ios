import Foundation
import SUINavigation
import SwiftUI

struct ExperiencePassesCardView: View {
    var package: Package
    var model: ExperienceDetailModel
    @State private var shouldNavigate: Bool = false
    @ObservedObject var viewModel: ExperienceAvailabilitySelectOptionsViewModel
    @ObservedObject var experienceDetailViewModel: ExperienceDetailViewModel

    let productCode: String
    let currency: String?
    let subActivityCode: String
    let uid: String
    let availabilityKey: String
    let gridLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // Filtered times — only non-empty strings
    private var validTimes: [String] {
        package.times.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 14) {
                // Title row
                HStack {
                    Text(package.title)
                        .font(.custom(Constants.Font.openSansBold, size: 12))
                        .foregroundColor(Color(hex: Constants.HexColors.blackStrong))
                    Spacer()
                    if !package.isExpanded,
                       let arrow = ImageLoader.bundleImage(named: Constants.Icons.arrowDown) {
                        arrow
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(hex: Constants.HexColors.primary))
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.toggleExpansion(for: package)
                }

                // Expanded content
                if package.isExpanded {
                    VStack(alignment: .leading, spacing: 0) {
                        // Info items (2-column)
                        let visibleItems = package.isInfoExpanded ? package.infoItems : Array(package.infoItems.prefix(2))
                        let leftColumn = visibleItems.enumerated().filter { $0.offset % 2 == 0 }.map { $0.element }
                        let rightColumn = visibleItems.enumerated().filter { $0.offset % 2 != 0 }.map { $0.element }
                        
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(leftColumn) { item in
                                    Label(item.title, systemImage: item.icon)
                                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                        .foregroundColor(Color(hex: Constants.HexColors.neutral))
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(rightColumn) { item in
                                    Label(item.title, systemImage: item.icon)
                                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                        .foregroundColor(Color(hex: Constants.HexColors.neutral))
                                }
                            }
                        }
                        
                        // More / Less info toggle
                        if !package.infoItems.isEmpty {
                            Text(package.isInfoExpanded ? Constants.SharedConstants.lessInfo : Constants.SharedConstants.moreInfo)
                                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                .foregroundColor(Color(hex: Constants.HexColors.primary))
                                .padding(.top, 8)
                                .onTapGesture {
                                    viewModel.toggleInfo(for: package)
                                }
                        }

                        // -------- TIME GRID: ONLY RENDER WHEN validTimes IS NON-EMPTY ----------
                        if !validTimes.isEmpty {
                            // The grid and its container are only created when real times exist.
                            LazyVGrid(columns: gridLayout, spacing: 8) {
                                ForEach(validTimes, id: \.self) { time in
                                    Button(action: {
                                        viewModel.selectTime(time, for: package)
                                    }) {
                                        Text(time)
                                            .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                            .foregroundColor(
                                                package.selectedTime == time
                                                ? Color(hex: Constants.HexColors.primary)
                                                : Color(hex: Constants.HexColors.neutral)
                                            )
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 34)
                                            .background(package.selectedTime == time ? Color(hex: Constants.HexColors.bgPremierWeak) : Color.white)
                                            .cornerRadius(4)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 4)
                                                    .stroke(
                                                        package.selectedTime == time
                                                        ? Color(hex: Constants.HexColors.primary)
                                                        : Color(hex: Constants.HexColors.neutralWeak),
                                                        lineWidth: 1
                                                    )
                                            )
                                    }
                                }
                            }
                            .padding(.top, 12)
                        }
                        // --------------------------------------------------------------------

                        // Total & pricing (always visible if totalAmount not empty)
                        if !package.totalAmount.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Total \(package.totalAmount)")
                                    .font(.custom(Constants.Font.openSansBold, size: 12))
                                    .foregroundColor(Color(hex: Constants.HexColors.secondary))
                                
//                                ForEach(package.pricingDescription, id: \.self) { line in
//                                    Text(line)
//                                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
//                                        .foregroundColor(Color(hex: Constants.HexColors.neutral))
//                                }
                            }
                            // If there are no times, reduce top padding so content moves up
                            .padding(.top, validTimes.isEmpty ? 8 : 18)

                            Button(action: {
                                shouldNavigate = true
                            }) {
                                Text(Constants.AvailabilityScreenConstants.bookThisExperience)
                                    .font(.custom(Constants.Font.openSansBold, size: 12))
                                    .foregroundColor(.white)
                                    .frame(height: 42)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(hex: Constants.HexColors.primary))
                                    .cornerRadius(4)
                            }
                            .padding(.top, 8)
                        }
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    .animation(.easeInOut(duration: 0.25), value: package.isExpanded)
                }
            }
            .padding(16)
            .background(
                // Use stroke + background without adding extra inner containers that could reserve space.
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        package.isExpanded
                        ? Color(hex: Constants.HexColors.primary)
                        : Color(hex: Constants.HexColors.neutralWeak),
                        style: package.isExpanded ? StrokeStyle(lineWidth: 1, dash: [3]) : StrokeStyle(lineWidth: 1)
                    )
                    .background(
                        (package.isExpanded ? Color(hex: Constants.HexColors.surfaceWeakest) : Color.white)
                            .cornerRadius(12)
                    )
            )
        }
        .onAppear {
            // Keep selecting first valid time if none selected
            if (package.selectedTime == nil), let first = validTimes.first {
                viewModel.selectTime(first, for: package)
            }
        }
        .navigation(isActive: $shouldNavigate, id: Constants.NavigationId.experienceCheckoutView) {
            ExperienceCheckoutView(
                checkoutViewModel: ExperienceCheckoutViewModel(productId: productCode),
                experienceDetailViewModel: experienceDetailViewModel,
                availabilityViewModel: viewModel,
                package: package,
                model: model,
                productCode: productCode,
                currency: currency ?? "",
                subActivityCode: subActivityCode,
                uid: uid,
                availabilityKey: availabilityKey
            )
        }
    }
}

