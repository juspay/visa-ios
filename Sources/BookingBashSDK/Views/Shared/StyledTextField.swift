import SwiftUI

public struct StyledTextField: View {
    public var placeholder: String
    @Binding public var text: String
    public var keyboardType: UIKeyboardType = .default
    
    public init(placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
    }
    
    public var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
            .cornerRadius(8)
            .frame(height: 44)
    }
}

public struct BareTextField: View {
    public var placeholder: String
    @Binding public var text: String
    public var keyboardType: UIKeyboardType = .default
    
    public init(placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
    }
    
    public var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
            .padding(.vertical, 12)
            .padding(.trailing, 12)
            .background(Color.white)
    }
}
