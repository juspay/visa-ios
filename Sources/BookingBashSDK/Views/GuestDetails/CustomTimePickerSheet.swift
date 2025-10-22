
import SwiftUI

struct CustomTimePickerSheet: View {
    @Binding var date: Date
    @Environment(\.presentationMode) var presentationMode
    @State private var hour: String = ""
    @State private var minute: String = ""

    var body: some View {
        VStack(spacing: 24) {
            Text("Select Time")
                .font(.system(size: 18, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 24)
                .padding(.horizontal, 24)
            Divider()
            HStack(spacing: 16) {
                timeField(title: "Hour", text: $hour, placeholder: "HH")
                timeField(title: "Minuts", text: $minute, placeholder: "MM")
            }
            .padding(.horizontal, 24)
            Button(action: {
                if let h = Int(hour), let m = Int(minute), (0...23).contains(h), (0...59).contains(m) {
                    let calendar = Calendar.current
                    let newDate = calendar.date(bySettingHour: h, minute: m, second: 0, of: date) ?? date
                    date = newDate
                    hideKeyboard()
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Ok")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color(red: 186/255, green: 146/255, blue: 82/255))
                    .cornerRadius(6)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            Spacer()
        }
        .onAppear {
            let comps = Calendar.current.dateComponents([.hour, .minute], from: date)
            hour = String(format: "%02d", comps.hour ?? 0)
            minute = String(format: "%02d", comps.minute ?? 0)
        }
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
        .contentShape(Rectangle())
        .onTapGesture { hideKeyboard() }
    }
    private func timeField(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14))
            TextField(placeholder, text: text)
                .keyboardType(.numberPad)
                .frame(height: 44)
                .multilineTextAlignment(.center)
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
                .cornerRadius(8)
        }
    }
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
