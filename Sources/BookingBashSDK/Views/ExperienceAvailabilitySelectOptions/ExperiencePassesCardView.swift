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

    // Filter valid times
    private var validTimes: [String] {
        package.times.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }

    // MARK: - Fare Summary Computation (Updated)
    private var detailedFareSummary: (items: [FareSummaryItem], discount: Double?, total: Double, currency: String) {
        guard let price = viewModel.response?.data?.result?.first?.rates.first?.price else {
            return ([], nil, 0, "")
        }
        var items: [FareSummaryItem] = []
        let currency = price.currency
        var total: Double = 0
        // Age band rows with improved label formatting
        for ageItem in price.pricePerAge {
            let type: String
            switch ageItem.bandId.uppercased() {
            case "ADULT":
                type = ageItem.count == 1 ? "Adult" : "Adults"
            case "CHILD":
                type = ageItem.count == 1 ? "Child" : "Children"
            case "INFANT":
                type = ageItem.count == 1 ? "Infant" : "Infants"
            case "CUSTOM":
                type = "Custom"
            default:
                type = ageItem.count == 1 ? ageItem.bandId.capitalized : ageItem.bandId.capitalized + "s"
            }
            let formattedPerPriceTraveller = String(format: "%.2f", ageItem.perPriceTraveller)
            let formattedBandTotal = String(format: "%.2f", ageItem.bandTotal)
            let label = "\(ageItem.count) \(type) x \(currency) \(formattedPerPriceTraveller)"
            let value = "\(currency) \(formattedBandTotal)"
            items.append(FareSummaryItem(label: label, value: value))
            total += ageItem.bandTotal
            
        }
        // Discount row
        var discount: Double? = nil
        if let strikeout = price.strikeout, strikeout.totalAmount > price.totalAmount {
            discount = strikeout.savingAmount
        }
        return (items, discount, price.totalAmount, currency)
       
    }


    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 14) {
                // MARK: - Title
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

                // MARK: - Expanded content
                if package.isExpanded {
                    VStack(alignment: .leading, spacing: 0) {

                        // MARK: - Info items (2-column)
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

                        // MARK: - More / Less info toggle
                        if !package.infoItems.isEmpty {
                            Text(package.isInfoExpanded ? Constants.SharedConstants.lessInfo : Constants.SharedConstants.moreInfo)
                                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                .foregroundColor(Color(hex: Constants.HexColors.primary))
                                .padding(.top, 8)
                                .onTapGesture {
                                    viewModel.toggleInfo(for: package)
                                }
                        }

                        // MARK: - TIME GRID
                        if !validTimes.isEmpty {
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

                        // MARK: - Fare Summary (below time slots)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Fare summary")
                                .font(.custom(Constants.Font.openSansBold, size: 14))
                                .foregroundColor(Color(hex: Constants.HexColors.blackStrong))
                                .padding(.bottom, 2)
                            ForEach(detailedFareSummary.items) { item in
                                HStack {
                                    Text(item.label)
                                        .font(.custom(Constants.Font.openSansRegular, size: 13))
                                        .foregroundColor(Color(hex: Constants.HexColors.blackStrong))
                                    Spacer()
                                    Text(item.value)
                                        .font(.custom(Constants.Font.openSansSemiBold, size: 13))
                                        .foregroundColor(Color(hex: Constants.HexColors.blackStrong))
                                }
                            }
                            // Always show discount, even if 0
                            HStack {
                                Text("Discount")
                                    .font(.custom(Constants.Font.openSansRegular, size: 13))
                                    .foregroundColor(Color(hex: Constants.HexColors.blackStrong))
                                Spacer()
                                Text("- \(detailedFareSummary.currency) \(String(format: "%.2f", detailedFareSummary.discount ?? 0.0))")
                                    .font(.custom(Constants.Font.openSansSemiBold, size: 13))
                                    .foregroundColor(Color(hex: "#2ECC40")) // Green
                            }
                            Divider()
                            HStack {
                                Text("Total")
                                    .font(.custom(Constants.Font.openSansBold, size: 15))
                                    .foregroundColor(Color(hex: Constants.HexColors.blackStrong))
                                Spacer()
                                Text("\(detailedFareSummary.currency) \(String(format: "%.2f", detailedFareSummary.total))")
                                    .font(.custom(Constants.Font.openSansBold, size: 15))
                                    .foregroundColor(Color(hex: Constants.HexColors.blackStrong))
                            }
                            Text("Prices inclusive of taxes")
                                .font(.custom(Constants.Font.openSansRegular, size: 12))
                                .foregroundColor(Color(hex: Constants.HexColors.neutral))
                                .padding(.top, 2)
                        }
                        .padding(.top, 16)

                        // MARK: - Book button
                        if !package.totalAmount.isEmpty {
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
                            .padding(.top, 16)
                        }
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    .animation(.easeInOut(duration: 0.25), value: package.isExpanded)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        package.isExpanded
                        ? Color(hex: Constants.HexColors.primary)
                        : Color(hex: Constants.HexColors.neutralWeak),
                        style: package.isExpanded
                        ? StrokeStyle(lineWidth: 1, dash: [3])
                        : StrokeStyle(lineWidth: 1)
                    )
                    .background(
                        (package.isExpanded
                         ? Color(hex: Constants.HexColors.surfaceWeakest)
                         : Color.white)
                            .cornerRadius(12)
                    )
            )
        }
        .onAppear {
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
                availabilityKey: availabilityKey,
                selectedTime: package.selectedTime ?? "" // <-- Pass selectedTime here
            )
        }
    }
}

// MARK: - Fare Summary Item
struct FareSummaryItem: Identifiable {
    let id = UUID()
    let label: String
    let value: String
}
