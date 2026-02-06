//
//  DatePickerView.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 22/01/26.
//

import SwiftUI

struct DatePickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var date: Date?
    let min: Date?
    let max: Date?
    let label: String
    var onContinue: (() -> Void)? = nil

    @State private var displayedMonth: Date = Date()
    @State private var showMonthPicker = false
    @State private var showYearPicker = false

    var body: some View {
        ThemeTemplateView(
            header: { headerSection },
            content: { contentSection }
        )
        .overlay {
            MonthPickerSheet(isPresented: $showMonthPicker,
                             selectedMonth: $displayedMonth)
        }
        .overlay {
            YearPickerSheet(isPresented: $showYearPicker,
                            selectedYear: $displayedMonth,
                            min: min,
                            max: max)
        }
        .onAppear {
            displayedMonth = date ?? Date()
        }
    }
}

extension DatePickerView {

    var headerSection: some View {
        ZStack {
            Text("Select \(label)") // You might want to pass the field label to the picker
                .font(.custom(Constants.Font.openSansBold, size: 14))
                .foregroundStyle(Color.white)
        }
    }

    var contentSection: some View {
       VStack(spacing: 16) {
           monthYearHeader
           weekdayHeader
           calendarGrid
           Spacer()
           continueButton
       }
       .padding()
   }

    var continueButton: some View {
        Button {
            onContinue?()
            dismiss()
        } label: {
            Text("Continue")
                .frame(maxWidth: .infinity)
                .padding()
                .background(date == nil ? Color.gray.opacity(0.4) : Color.brown)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .disabled(date == nil)
        .padding(.bottom, 8)
    }
}

extension DatePickerView {
    var monthYearHeader: some View {
        HStack {
            Button {
                displayedMonth = displayedMonth.addingMonths(-1)
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color(hex: Constants.HexColors.primary))
            }

            Spacer()

            HStack(spacing: 20) {
                Text(displayedMonth.monthName)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundColor(Color(hex: Constants.HexColors.secondary))
                if let arrow = ImageLoader.bundleImage(named: Constants.Icons.arrowDown) {
                    arrow
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color(hex: Constants.HexColors.primary))
                }
            }
            .padding(.vertical, 9)
            .padding(.horizontal, 6)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(hex: Constants.HexColors.neutralWeak),
                        lineWidth: 1
                    ))
            .contentShape(Rectangle())
            .onTapGesture {
                showMonthPicker = true
            }
            .padding(.trailing, 16)

            HStack(spacing: 20) {
                Text(displayedMonth.yearString)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundColor(Color(hex: Constants.HexColors.secondary))
                if let arrow = ImageLoader.bundleImage(named: Constants.Icons.arrowDown) {
                    arrow
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color(hex: Constants.HexColors.primary))
                }
            }
            .padding(.vertical, 9)
            .padding(.horizontal, 6)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(hex: Constants.HexColors.neutralWeak),
                        lineWidth: 1
                    ))
            .contentShape(Rectangle())
            .onTapGesture {
                showYearPicker = true
            }

            Spacer()

            Button {
                displayedMonth = displayedMonth.addingMonths(1)
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(hex: Constants.HexColors.primary))
            }
        }
        .font(.subheadline.bold())
    }

    var weekdayHeader: some View {
        HStack {
            ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) {
                Text($0)
                    .frame(maxWidth: .infinity)
                    .font(.caption)
            }
        }
    }
    
    var calendarGrid: some View {
        let days = displayedMonth.calendarDays()

        return LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
            ForEach(days, id: \.self) { day in
                DayCell(
                    date: day,
                    selectedDate: $date,
                    displayedMonth: displayedMonth,
                    min: min,
                    max: max
                )
            }
        }
    }
}

struct DayCell: View {
    let date: Date
    @Binding var selectedDate: Date?
    let displayedMonth: Date
    let min: Date?
    let max: Date?

    var isDisabled: Bool {
        if let min, date < min { return true }
        if let max, date > max { return true }
        return !Calendar.current.isDate(date, equalTo: displayedMonth, toGranularity: .month)
    }

    var isSelected: Bool {
        selectedDate.map { Calendar.current.isDate($0, inSameDayAs: date) } ?? false
    }

    var body: some View {
        Text(date.dayString)
            .frame(width: 36, height: 36)
            .contentShape(Rectangle())
            .background(isSelected ? Color.blue : Color.clear)
            .foregroundColor(isDisabled ? .gray : isSelected ? .white : .primary)
            .clipShape(Circle())
            .onTapGesture {
                guard !isDisabled else { return }
                let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
                
                if let newDate = Calendar.current.date(from: components) {
                    selectedDate = newDate
                }
            }
    }
}

struct MonthPickerSheet: View {
    @Binding var isPresented: Bool
    @Binding var selectedMonth: Date

    let months = Calendar.current.shortMonthSymbols

    var body: some View {
        BottomSheetView(isPresented: $isPresented) {
            VStack(spacing: 20) {
                Text("Select Month")
                    .font(.custom(Constants.Font.openSansBold, size: 16))
                    .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                    .padding(.top, 10)

                // 2. Grid of 3 Columns
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 12) {
                    ForEach(months.indices, id: \.self) { index in
                        
                        let isSelected = Calendar.current.component(.month, from: selectedMonth) == (index + 1)
                        
                        Button {
                            // Calendar months are 1-based (1=Jan), indices are 0-based
                            selectedMonth = selectedMonth.settingMonth(index + 1)
                            isPresented = false
                        } label: {
                            Text(months[index])
                                .font(.custom(Constants.Font.openSansRegular, size: 14))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    isSelected
                                    ? Color(hex: Constants.HexColors.primary)
                                    : Color.white
                                )
                                .foregroundColor(isSelected ? .white : .primary)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(hex: Constants.HexColors.neutralWeak), lineWidth: isSelected ? 0 : 1)
                                )
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
    }
}

struct YearPickerSheet: View {
    @Binding var isPresented: Bool
    @Binding var selectedYear: Date
    let min: Date?
    let max: Date?

    var body: some View {
        BottomSheetView(isPresented: $isPresented) {
            ScrollView {
                VStack {
                    Text("Select Year").bold()
                    ForEach(yearRange, id: \.self) { year in
                        Text(String(year))
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color(hex: Constants.ColorConstants.strokeColor), lineWidth: 1)
                            )
                            .padding()
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedYear = selectedYear.settingYear(year)
                                isPresented = false
                            }
                    }
                }
            }
            .frame(height: UIScreen.main.bounds.height * 0.8)
        }
    }

    var yearRange: [Int] {
        let current = Calendar.current.component(.year, from: Date())
        let minYear = min.map { Calendar.current.component(.year, from: $0) } ?? (current - 100)
        let maxYear = max.map { Calendar.current.component(.year, from: $0) } ?? current
        return Array((minYear...maxYear).reversed())
    }
}

extension Date {

    var monthName: String {
        DateFormatter().monthSymbols[Calendar.current.component(.month, from: self) - 1]
    }

    var yearString: String {
        String(Calendar.current.component(.year, from: self))
    }

    var dayString: String {
        String(Calendar.current.component(.day, from: self))
    }

    func addingMonths(_ value: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: value, to: self)!
    }

    func settingMonth(_ month: Int) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.month = month
        
        // 1. Try to create the date directly
        if let date = Calendar.current.date(from: components) {
            return date
        }
        
        // 2. If failed (e.g., Feb 31), just use the 1st of that month to avoid crash,
        // or clamp to the last day of the month logic (more complex, but 1st is safe)
        // Better UX: Clamp to valid day
        let tempComponents = DateComponents(year: components.year, month: month)
        if let range = Calendar.current.range(of: .day, in: .month, for: Calendar.current.date(from: tempComponents)!) {
            components.day = range.upperBound - 1 // Last valid day
            return Calendar.current.date(from: components) ?? self
        }
        
        return self
    }
    
    func settingYear(_ year: Int) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.year = year
        
        // 1. Try to create the exact date
        if let date = Calendar.current.date(from: components) {
            return date
        }
        
        // 2. If nil (e.g., Feb 29 -> 2025), fallback to Feb 28
        if components.month == 2 && components.day == 29 {
            components.day = 28
            return Calendar.current.date(from: components) ?? self
        }
        
        return self
    }

    func calendarDays() -> [Date] {
        let calendar = Calendar.current
        
        // Get the first day of the month
        let components = calendar.dateComponents([.year, .month], from: self)
        guard let firstOfMonth = calendar.date(from: components) else { return [] }
        
        let range = calendar.range(of: .day, in: .month, for: self)!
        
        // Calculate offset (Sunday = 1, Monday = 2, etc.)
        let weekday = calendar.component(.weekday, from: firstOfMonth)
        // Adjust based on your calendar's first day (usually Sunday in iOS defaults)
        let weekdayOffset = weekday - calendar.firstWeekday
        
        // Handle negative offset if wrapping weeks
        let safeOffset = weekdayOffset < 0 ? weekdayOffset + 7 : weekdayOffset

        // Create Unique Padding Dates
        // Instead of repeating 'distantPast', we generate unique distant dates
        // just to keep the ForEach happy (e.g., distantPast + 1 second, + 2 seconds)
        let paddingDays = (0..<safeOffset).map { i in
            return calendar.date(byAdding: .second, value: i, to: Date.distantPast)!
        }
        
        let actualDays = range.compactMap {
            calendar.date(byAdding: .day, value: $0 - 1, to: firstOfMonth)
        }

        return paddingDays + actualDays
    }
}


#Preview {
    DatePickerView(
        date: .constant(nil),
        min: Calendar.current.date(from: DateComponents(year: 1900, month: 1, day: 1)),
        max: Date(),
        label: "Birth Date"
    )
}
