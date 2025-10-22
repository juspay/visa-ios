import SwiftUI

struct Checkbox: View {
    @Binding var isOn: Bool
    
    var body: some View {
        Button {
            withAnimation { isOn.toggle() }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gray.opacity(0.45), lineWidth: 1.5)
                    .frame(width: 22, height: 22)
                    .background(isOn ? Color(.systemBlue).opacity(0.15) : Color.clear)
                if isOn {
                    Image(systemName: Constants.GuestDetailsFormConstants.systemNameCheckmark)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(.systemBlue))
                }
            }
        }
        .buttonStyle(.plain)
    }
}
