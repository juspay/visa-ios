import Foundation
import SUINavigation
import SwiftUI

struct CustomCalendarView: View {
    @StateObject private var viewModel = ExperienceAvailabilitySelectOptionsViewModel()
    @State private var shouldNavigateToAvailabilityScreen: Bool = false
    @State private var showParticipantsSheet: Bool = false
    
    var model: ExperienceDetailModel
    @ObservedObject var experienceDetailViewModel: ExperienceDetailViewModel

    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    var productCode: String?
    var currency: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(Constants.AvailabilityScreenConstants.selectDate)
                .font(.custom(Constants.Font.openSansBold, size: 14))
                .foregroundStyle(Color(hex: Constants.HexColors.secondary))
            
            HStack(spacing: 12) {
                Button(action: {
                    viewModel.selectToday()
                    showParticipantsSheet = true
                }) {
                    Text(Constants.AvailabilityScreenConstants.today)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 14))
                        .foregroundStyle(Color(hex: Constants.HexColors.secondary))
                }
                .frame(height: 34)
                .buttonStyle(CalendarButtonStyle())
                
                Button(action: {
                    viewModel.selectTomorrow()
                    showParticipantsSheet = true
                }) {
                    Text(Constants.AvailabilityScreenConstants.tomorrow)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 14))
                        .foregroundStyle(Color(hex: Constants.HexColors.secondary))
                }
                .frame(height: 34)
                .buttonStyle(CalendarButtonStyle())
            }
            
            LazyVGrid(columns: columns) {
                ForEach(Constants.AvailabilityScreenConstants.weekdays, id: \.self) { day in
                    Text(day)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 14))
                        .foregroundStyle(Color(hex: Constants.HexColors.secondary))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
            }
            .padding(.vertical, 6)
            .background(Color.gray.opacity(0.08))
            .cornerRadius(10)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.months) { month in
                        VStack(alignment: .leading, spacing: 12) {
                            Text("\(month.name) \(String(month.year))")
                                .font(.custom(Constants.Font.openSansBold, size: 14))
                                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                            
                            LazyVGrid(columns: columns, spacing: 12) {
                                ForEach(month.days) { day in
                                    CalendarDayView(
                                        day: day,
                                        isSelected: viewModel.isSameDay(day.date, viewModel.selectedDateFromCalender)
                                    ) {
                                        viewModel.dateSelectedFromCalender(date: day.date)
                                        showParticipantsSheet = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        // Navigate to AvailabilitySelectionMainView after participants are selected
        .navigation(isActive: $shouldNavigateToAvailabilityScreen, id: Constants.NavigationId.availabilitySelectionMainView) {
            AvailabilitySelectionMainView(
                experienceAvailabilitySViewModel: viewModel,
                model: model,
                experienceDetailViewModel: experienceDetailViewModel,
                productCode: productCode,
                currency: currency
            )
        }
        // Show participant selection as bottom sheet
        .overlay(
            BottomSheetView(isPresented: $showParticipantsSheet) {
                ParticipantSelectionView(
                    viewModel: viewModel,
                    onSelect: {
                        showParticipantsSheet = false
                        shouldNavigateToAvailabilityScreen = true
                    }
                )
            }
        )
    }
}

struct CalendarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom(Constants.Font.openSansSemiBold, size: 12))
            .foregroundStyle(Color(hex: Constants.HexColors.secondary))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.white)
            .cornerRadius(4)
            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(hex: Constants.HexColors.neutralWeak), lineWidth: 1))
    }
}
