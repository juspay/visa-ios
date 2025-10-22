import SwiftUI

struct CustomCalendarPicker: View {
    @Binding var date: Date
    var minDate: Date? = nil
    var maxDate: Date? = nil
    var onDone: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 8) {
            DatePicker(
                "",
                selection: Binding(
                    get: { date },
                    set: { newValue in
                        date = newValue
                        onDone?() // Automatically call onDone when a date is selected
                    }
                ),
                in: (minDate ?? Date.distantPast)...(maxDate ?? Date.distantFuture),
                displayedComponents: .date
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .labelsHidden()
            .frame(width: 320, height: 320) // fixed size
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 5)
        }
    }
}
