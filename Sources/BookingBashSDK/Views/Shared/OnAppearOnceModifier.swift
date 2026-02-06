//
//  OnAppearOnceModifier.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 18/12/25.
//

import SwiftUI

// Custom modifier to execute an action only once when the view appears
struct OnAppearOnceModifier: ViewModifier {
    @State private var hasAppeared = false
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !hasAppeared {
                    action()
                    hasAppeared = true
                }
            }
    }
}
