//
//  StackItemToolbar.swift
//  TestSwiftUI
//
//  Created by hamed on 9/24/23.
//

import SwiftUI

struct ToolbarItem: Identifiable {
    let id: UUID = UUID()
    let value: AnyView

    init(value: AnyView) {
        self.value = value
    }
}

final class StackItemToolbar: ObservableObject {
    private(set) var title: String?
    private(set) var leadingItems: [ToolbarItem] = []
    private(set) var trailingItems: [ToolbarItem] = []

    init(title: String? = nil, leadingItems: [ToolbarItem] = [], trailingItems: [ToolbarItem] = []) {
        self.title = title
        self.leadingItems = leadingItems
        self.trailingItems = trailingItems
    }

    func appendLeading(_ item: ToolbarItem) {
        leadingItems.append(item)
        objectWillChange.send()
    }

    func appendTrailing(_ item: ToolbarItem) {
        trailingItems.append(item)
        objectWillChange.send()
    }

    func popAllToolbarViews() {
        leadingItems.removeAll()
        trailingItems.removeAll()
        objectWillChange.send()
    }

    func setTitle(title: String) {
        self.title = title
        objectWillChange.send()
    }
}

struct StackItemToolbar_Previews: PreviewProvider {
    static var previews: some View {
        Text("Test")
    }
}

private struct StackToolbarImageButtonModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .scaledToFit()
            .frame(width: 18, height: 18)
            .padding(6)
    }
}

public extension Image {
    func toolbarImageItemStyle() -> some View {
        resizable()
            .modifier(StackToolbarImageButtonModifier())
    }
}
