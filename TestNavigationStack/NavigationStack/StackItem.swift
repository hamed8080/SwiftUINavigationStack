//
//  StackItem.swift
//  TestSwiftUI
//
//  Created by hamed on 9/24/23.
//

import Foundation

public struct StackItem: Hashable, Identifiable, Equatable {
    public static func == (lhs: StackItem, rhs: StackItem) -> Bool {
        lhs.value.hashValue == rhs.value.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(value.hashValue)
    }

    public var id: Int { value.hashValue }
    let value: AnyHashable
    var toolbarItems: StackItemToolbar

    init(value: AnyHashable, toolbarItems: StackItemToolbar = .init()) {
        self.value = value
        self.toolbarItems = toolbarItems
    }
}
