import Foundation
import SUINavigation
import SwiftUI

struct ExperiencePassesCardView: View {
    var package: Package
    var model: ExperienceDetailModel
    @Binding var showPriceChangeSheet: Bool
    @ObservedObject var viewModel: ExperienceAvailabilitySelectOptionsViewModel
    @ObservedObject var experienceDetailViewModel: ExperienceDetailViewModel

    @State private var showMoreText: Bool = false
    @State private var isBooking: Bool = false
    @State private var availableSlot: Int = 0
    @State private var currentSlotAvailable: Bool = false
    
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
    private var validSlotData: [SlotDetails] {
        package.slotDetails.filter { data in
            !data.time.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    // MARK: - Fare Summary Computation (Updated)
    private var detailedFareSummary: (items: [FareSummaryItem], discount: Double?, total: Double, currency: String) {
        guard let price = viewModel.response?.data?.result?.first?.rates.first?.price else {
            return ([], nil, 0, "")
        }
        var items: [FareSummaryItem] = []
        let currency = price.currency
        var total: Double = 0
        for ageItem in price.pricePerAge {
            let type: String
            switch ageItem.bandId.uppercased() {
            case "ADULT":
                type = ageItem.count == 1 ? "Adult" : "Adults"
            case "CHILD":
                type = ageItem.count == 1 ? "Child" : "Children"
            case "INFANT":
                type = ageItem.count == 1 ? "Infant" : "Infants"
            case "FAMILY":
                type = ageItem.count == 1 ? "Family" : "Families"
            case "PERSON":
                type = ageItem.count == 1 ? "Person" : "People"
            case "CUSTOM":
                type = "Custom"
            default:
                type = ageItem.count == 1 ? ageItem.bandId.capitalized : ageItem.bandId.capitalized + "s"
            }
            let formattedPerPriceTraveller = ageItem.perPriceTraveller.commaSeparated()
            let formattedBandTotal = ageItem.bandTotal.commaSeparated()
            let label = "\(ageItem.count) \(type) x \(currency) \(formattedPerPriceTraveller)"
            let value = "\(currency) \(formattedBandTotal)"
            items.append(FareSummaryItem(label: label, value: value))
            total += ageItem.bandTotal
        }
        // Discount row
        var discount: Double? = nil
        if let strikeout = price.strikeout, let totalAmount = strikeout.totalAmount, totalAmount > price.totalAmount {
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
                        if !package.subActivityDescription.isEmpty {
                            expandableTextView(text: package.subActivityDescription)
                        }
                        
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
                            Text(package.isInfoExpanded ? Constants.ExperiencePassesCardViewConstants.lessInfo : Constants.ExperiencePassesCardViewConstants.moreInfo)
                                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                .foregroundColor(Color(hex: Constants.HexColors.primary))
                                .padding(.top, 8)
                                .onTapGesture {
                                    viewModel.toggleInfo(for: package)
                                }
                        }
                        
                        // MARK: - TIME GRID
                        if !validSlotData.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                if currentSlotAvailable, availableSlot != 0 {
                                    HStack {
                                        Text("Available Slots")
                                            .font(.custom(Constants.Font.openSansBold, size: 12))
                                            .foregroundColor(Color(hex: Constants.HexColors.blackStrong))
                                        Text("\(availableSlot)")
                                            .font(.custom(Constants.Font.openSansBold, size: 12))
                                            .foregroundColor(Color(hex: Constants.HexColors.greenShade))
                                    }
                                    .padding(5)
                                    .background(Color(hex: Constants.HexColors.bgPremierWeak))
                                    .cornerRadius(4)
                                }
                                LazyVGrid(columns: gridLayout, spacing: 8) {
                                    ForEach(validSlotData, id: \.id) { data in
                                        Button(action: {
                                            viewModel.selectTime(data.time, for: package)
                                            availableSlot = data.availableTimeSlot
                                            currentSlotAvailable = data.availabilityStatus
                                        }) {
                                            Text(data.time)
                                                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                                .foregroundColor(
                                                    package.selectedTime == data.time
                                                    ? Color(hex: Constants.HexColors.primary)
                                                    : Color(hex: Constants.HexColors.neutral)
                                                )
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 34)
                                                .background(package.selectedTime == data.time ? Color(hex: Constants.HexColors.bgPremierWeak) : Color.white)
                                                .cornerRadius(4)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .stroke(
                                                            package.selectedTime == data.time
                                                            ? Color(hex: Constants.HexColors.primary)
                                                            : Color(hex: Constants.HexColors.neutralWeak),
                                                            lineWidth: 1
                                                        )
                                                )
                                        }
                                    }
                                }
                            }
                            .padding(.top, 16)
                        }
                        
                        // MARK: - Fare Summary (below time slots)
                        VStack(alignment: .leading, spacing: 8) {
                            Text(Constants.ExperiencePassesCardViewConstants.fareSummary)
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
                                        .font(.custom(Constants.Font.openSansRegular, size: 13))
                                        .foregroundColor(Color(hex: Constants.HexColors.blackStrong))
                                }
                            }
                            HStack {
                                Text(Constants.ExperiencePassesCardViewConstants.discount)
                                    .font(.custom(Constants.Font.openSansRegular, size: 13))
                                    .foregroundColor(Color(hex: Constants.HexColors.blackStrong))
                                Spacer()
                                Text("- \(detailedFareSummary.currency) \(detailedFareSummary.discount?.commaSeparated() ?? "0.00")")
                                    .font(.custom(Constants.Font.openSansSemiBold, size: 13))
                                    .foregroundColor(Color(hex: "#2ECC40")) // Green
                            }
                            Divider()
                            HStack {
                                Text(Constants.ExperiencePassesCardViewConstants.total)
                                    .font(.custom(Constants.Font.openSansBold, size: 15))
                                    .foregroundColor(Color(hex: Constants.HexColors.blackStrong))
                                Spacer()
                                
                                Text("\(detailedFareSummary.currency) \(detailedFareSummary.total.commaSeparated())")
                                
                                    .font(.custom(Constants.Font.openSansBold, size: 15))
                                    .foregroundColor(Color(hex: Constants.HexColors.blackStrong))
                            }
                            Text(Constants.ExperiencePassesCardViewConstants.pricesInclusiveOfTaxes)
                                .font(.custom(Constants.Font.openSansRegular, size: 12))
                                .foregroundColor(Color(hex: Constants.HexColors.neutral))
                                .padding(.top, 2)
                        }
                        .padding(.top, 16)
                        
                        // MARK: - Book button
                        if !package.totalAmount.isEmpty {
                            Button(action: {
                                isBooking = true
                                priceCheck()
                            }) {
                                Text(Constants.ExperiencePassesCardViewConstants.bookThisExperience)
                                    .font(.custom(Constants.Font.openSansBold, size: 12))
                                    .foregroundColor(.white)
                                    .frame(height: 42)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(hex: Constants.HexColors.primary))
                                    .cornerRadius(4)
                            }
                            .disabled(isBooking)
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
            if (package.selectedTime == nil), let first = validSlotData.first {
                viewModel.selectTime(first.time, for: package)
                availableSlot = first.availableTimeSlot
                currentSlotAvailable = first.availabilityStatus
            }
        }
    }
    
    // MARK: - Expandable Text View as method
    func expandableTextView(text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(text)
                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                .multilineTextAlignment(.leading)
                .lineLimit(showMoreText ? nil : 2)
            Button {
                showMoreText.toggle()
            } label: {
                HStack(spacing: 4) {
                    Text(showMoreText ? Constants.SharedConstants.viewLess : Constants.SharedConstants.viewMore)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.primary))
                    if let arrow = ImageLoader.bundleImage(named: Constants.Icons.arrowDown) {
                        arrow
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(hex: Constants.HexColors.primary))
                            .rotationEffect(.degrees(showMoreText ? 180 : 0))
                    }
                }
            }
        }
    }
    func priceCheck() {
        let travelerDetails: [TravelerDetailsRequest] = viewModel.categories
            .filter { $0.count > 0 }
            .map { category in
                let ageBand = category.bandId.isEmpty ? category.type.uppercased() : category.bandId
                return TravelerDetailsRequest(ageBand: ageBand, travelerCount: category.count)
            }
        
        let availabilityItem = viewModel.response?.data?.result?.first
        
        let request = PriceCheckRequest(
            siteId: ssoSiteIdGlobal,
            activityCode: productCode,
            currency: currencyGlobal,
            checkInDate: viewModel.formatter.string(from: viewModel.selectedDateFromCalender),
            availabilityCacheUID: viewModel.response?.data?.uid ?? "",
            availabilityId: availabilityItem?.availabilityId ?? "",
            availabilityKey: availabilityItem?.availabilityKey ?? "",
            detailUID: detaislUid,
            rateCode: subActivityCode,
            activityExternalCode: availabilityItem?.activityExternalCode ?? "",
            travelerDetails: travelerDetails
        )
        
        viewModel.priceCheck(request: request) { result in
            DispatchQueue.main.async {
                self.isBooking = false // 3. Stop Loading on callback
                
                switch result {
                case .success(let response):
                    viewModel.priceCheckResponse = response
                    if let priceChanged = response.data?.priceChanged, priceChanged {
                        showPriceChangeSheet = true
                    } else {
                        viewModel.navigateToCheckout = true
                    }
                case .failure(_):
                    showPriceChangeSheet = true // Or handle error appropriately
                    print("Error during price check")
                }
            }
        }
    }
}

// MARK: - Fare Summary Item
struct FareSummaryItem: Identifiable {
    let id = UUID()
    let label: String
    let value: String
}
