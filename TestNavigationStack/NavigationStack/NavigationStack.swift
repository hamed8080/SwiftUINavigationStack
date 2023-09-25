//
//  NavigationStack.swift
//  TestSwiftUI
//
//  Created by hamed on 9/23/23.
//

import SwiftUI
import Foundation

struct NavigationStackBody<Content: View>: View {
    @EnvironmentObject var viewModel: StackViewModel
    private let isPhone = UIDevice.current.userInterfaceIdiom == .phone
    let rootItem: StackItem
    var onPushStackItem: (StackItem) -> (Content)

    var body: some View {
        ZStack {
            ZStack {
                ForEach(viewModel.stackItems) { stackItem in
                    StackItemView(stackItem: stackItem, onPushStackItem: self.onPushStackItem, offsetX: self.viewModel.offsetX)
                }
            }
            .simultaneousGesture(leadingGesture)
            .compatibleSafeAreaInset(edge: .top) {
                Spacer()
                    .frame(height: 42)
            }
            NavigationStackToolbarContainer()
                .id(viewModel.stackItems.last?.id ?? rootItem.id)
                .environmentObject(viewModel.stackItems.last?.toolbarItems ?? rootItem.toolbarItems)
        }
        .animation(.easeInOut, value: viewModel.stackItems.count)
        .environmentObject(viewModel)
        .onAppear {
            self.viewModel.append(self.rootItem)
        }
    }

    /// In iPhone devices, we need to use a gesture to simulate swipe-to-back functionality.
    var leadingGesture: some Gesture {
        DragGesture(minimumDistance: 1, coordinateSpace: .global)
            .onChanged { value in
                if !self.canSlide { return }
                if value.startLocation.x < 16 {
                    self.viewModel.offsetX = value.location.x
                    if value.translation.width > self.viewModel.width / 2 {
                        self.viewModel.goToPreviousPage()
                    }
                }
            }.onEnded { value in
                if !self.canSlide { return }
                if value.location.x < self.viewModel.width / 2 {
                    self.viewModel.offsetX = 0
                }
            }
    }

    var canSlide: Bool { isPhone && viewModel.stackItems.count > 1 }
}


struct NavigationStack<Content: View>: View {
    let viewModel: StackViewModel
    let rootItem: StackItem
    var onPushStackItem: (StackItem) -> (Content)

    init(viewModel: StackViewModel, rootItem: StackItem, onPushStackItem: @escaping (StackItem) -> (Content)) {
        self.viewModel = viewModel
        self.rootItem = rootItem
        self.onPushStackItem = onPushStackItem
    }

    var body: some View {
        NavigationStackBody(rootItem: rootItem, onPushStackItem: onPushStackItem)
            .environmentObject(viewModel)
    }
}

struct StackItemView<Content: View>: View {
    let stackItem: StackItem
    let onPushStackItem: (StackItem) -> (Content)
    let offsetX: CGFloat
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        onPushStackItem(stackItem)
            .environment(\.stackItem, stackItem)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .background(colorScheme == .dark ? Color.black : Color.white)
            .offset(x: offsetX)
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
    }
}

struct CustomNavigationStack_Previews: PreviewProvider {
    struct TestSatckItem: View {
        var body: some View {
            Text("Item 1")
        }
    }

    static var previews: some View {
        NavigationStack(viewModel: .init(), rootItem: .init(value: "TEST")) { tsackItem in
            TestSatckItem()
        }
    }
}

struct StackItemEnvironmentKey: EnvironmentKey {
    static var defaultValue: StackItem?
}

extension EnvironmentValues {
    var stackItem: StackItem? {
        get { self[StackItemEnvironmentKey.self] }
        set { self[StackItemEnvironmentKey.self] = newValue }
    }
}
