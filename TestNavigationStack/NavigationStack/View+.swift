//
//  View+.swift
//  TestSwiftUI
//
//  Created by hamed on 9/25/23.
//

import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

public extension View {
    func compatibleMaterialBackground(colorScheme: ColorScheme) -> some View {
        background(
            GeometryReader { reader in
                Rectangle()
                    .fill(colorScheme == .dark ? Color.black.opacity(0.5) : Color.black.opacity(0.2))
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: reader.size.width, height: reader.size.height)
                    .background(VisualEffectView(effect: UIBlurEffect(style: .regular)).edgesIgnoringSafeArea(.all))
            }
        )
    }
}

public extension View {
    func compatibleSafeAreaInset<V>(edge: Edge.Set, spacing: CGFloat? = nil, content: @escaping () -> (V)) -> some View where V: View {
            GeometryReader { reader in
                ZStack {
                self
                    .padding(edge, spacing ?? reader.safeAreaInsets.top)
                content()
            }
        }
    }
}
