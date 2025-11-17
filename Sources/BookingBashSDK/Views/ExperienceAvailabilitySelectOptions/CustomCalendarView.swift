import Foundation
import SUINavigation
import SwiftUI

struct CustomCalendarView: View {
    @ObservedObject var viewModel: ExperienceAvailabilitySelectOptionsViewModel
    @State private var shouldNavigateToAvailabilityScreen: Bool = false
    
    @Binding var showParticipantsSheet: Bool
    @Binding var shouldPresentCalenderView: Bool
    var isFromDetailView: Bool = false
    
    var model: ExperienceDetailModel
    @ObservedObject var experienceDetailViewModel: ExperienceDetailViewModel
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    var productCode: String?
    var currency: String?
    
    private let weekdays = Calendar.current.shortWeekdaySymbols
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(Constants.AvailabilityScreenConstants.selectDate)
                .font(.custom(Constants.Font.openSansBold, size: 14))
                .foregroundStyle(Color(hex: Constants.HexColors.secondary))
            
            LazyVGrid(columns: columns) {
                ForEach(Constants.AvailabilityScreenConstants.weekdays, id: \.self) { day in
                    Text(day)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.secondary))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 8)
            
            // MARK: - Month and Dates
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
                                        viewModel.refreshAvailabilityAfterParticipantChange()
                                        
                                        
                                        if isFromDetailView {
                                            shouldNavigateToAvailabilityScreen = true
                                        } else {
                                            shouldPresentCalenderView = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .navigation(
            isActive: $shouldNavigateToAvailabilityScreen,
            id: Constants.NavigationId.availabilitySelectionMainView
        ) {
            AvailabilitySelectionMainView(
                experienceAvailabilitySViewModel: viewModel,
                model: model,
                experienceDetailViewModel: experienceDetailViewModel,
                productCode: productCode,
                currency: currency,
                showParticipantsSheet: $showParticipantsSheet,
                fromDetailFlow: true
            )
        }
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
