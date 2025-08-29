//
//  effwef.swift
//  VisaActivity
//
//  Created by Apple on 30/07/25.
//

import Foundation
import SwiftUI

struct SwipeToDismissBottomSheet<Content: View>: View {
    var onDismiss: () -> Void
    var content: () -> Content

    @GestureState private var dragOffset: CGFloat = 0

    var body: some View {
        VStack {
            Spacer(minLength: 22)

            content()
                .offset(y: dragOffset > 0 ? dragOffset : 0)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation.height
                        }
                        .onEnded { value in
                            if value.translation.height > 100 {
                                onDismiss()
                            }
                        }
                )
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
