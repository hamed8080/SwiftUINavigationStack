//
//  View+.swift
//  TestSwiftUI
//
//  Created by hamed on 9/25/23.
//

import SwiftUI

//@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
//public struct MaterialBackgroundModifier: ViewModifier {
//    let material: Material
//
//    public init(material: Material) {
//        self.material = material
//    }
//
//    public func body(content: Content) -> some View {
//        content.background(.regularMaterial)
//    }
//}


struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

public extension View {
//
//    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
//    func materialBackground(_ material: Material) -> some View {
//        return background(material)
//    }

    func materialBackground(colorScheme: ColorScheme) -> some View {
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

//    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//    func compatibleSafeAreaInset<V>(_ edgeSet: VerticalEdge, alignment: HorizontalAlignment, spacing: CGFloat? = nil, @ViewBuilder content: () ->(V)) -> some View where V: View {
//        return safeAreaInset(edge: edgeSet, alignment: alignment, spacing: spacing, content: content)
//    }
//
//    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//    func compatibleSafeAreaInset<V>(_ edgeSet: HorizontalEdge, alignment: VerticalAlignment, spacing: CGFloat? = nil, @ViewBuilder content: () ->(V)) -> some View where V : View {
//        return safeAreaInset(edge: edgeSet, alignment: alignment, spacing: spacing, content: content)
//    }

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

public extension View {
    func overlay<V>(alignment: Alignment = .center, content: V) -> some View where V: View {
        overlay(content, alignment: alignment)
    }
}
