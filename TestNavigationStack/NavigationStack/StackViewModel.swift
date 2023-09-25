//
//  StackViewModel.swift
//  TestSwiftUI
//
//  Created by hamed on 9/24/23.
//

import SwiftUI

public final class StackViewModel: ObservableObject {
    @Published private(set) var stackItems: [StackItem]
    @Published var offsetX: CGFloat
    @Published var width: CGFloat
    @Published var isRemoving: Bool

    public init(stackItems: [StackItem] = [], offsetX: CGFloat = 0, width: CGFloat = 300, isRemoving: Bool = false) {
        self.stackItems = stackItems
        self.offsetX = offsetX
        self.width = width
        self.isRemoving = isRemoving
    }

    func append(_ item: StackItem) {
        stackItems.append(item)
    }

    func popLast() {
        _ = stackItems.popLast()
    }

    func goToPreviousPage() {
        if isRemoving { return }
        // Move the view to the trailing part of the screen
        offsetX = width
        stackItems.last?.toolbarItems.popAllToolbarViews()
        stackItems.last?.toolbarItems.popAllToolbarViews()
        _ = stackItems.popLast()
        isRemoving = true
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            /// Rest the Item view offset
            self.offsetX = 0
            self.isRemoving = false
        }
    }

    func appendLeading(_ item: AnyView, _ stackItem: StackItem) {
        if let stackItemIndex = stackItems.firstIndex(where: {$0 == stackItem }) {
            stackItems[stackItemIndex].toolbarItems.appendLeading(.init(value: item))
            animateObjectWillChange()
        }
    }

    func appendTrailing(_ item: AnyView, _ stackItem: StackItem) {
        if let stackItemIndex = stackItems.firstIndex(where: {$0 == stackItem }) {
            stackItems[stackItemIndex].toolbarItems.appendTrailing(.init(value: item))
            animateObjectWillChange()
        }
    }

    func animateObjectWillChange() {
        withAnimation {
            objectWillChange.send()
        }
    }
}
