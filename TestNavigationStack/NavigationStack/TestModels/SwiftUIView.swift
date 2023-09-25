//
//  SwiftUIView.swift
//  TestSwiftUI
//
//  Created by hamed on 9/24/23.
//

import SwiftUI

var fakeStakItems: [StackItem] = [
    .init(value: 34, toolbarItems: .init(title: "Integer")),
    .init(value: 0.8374, toolbarItems: .init(title: "Double")),
    .init(value: "Hamed", toolbarItems: .init(title: "String")),
    .init(value: "15785", toolbarItems: .init(title: "String")),
    .init(value: 5882.6, toolbarItems: .init(title: "Double"))
]

struct TestCustomNavigationStack: View {
    private let rootItem = StackItem(value: UUID(), toolbarItems: .init(title: "RootView"))

    var body: some View {
        NavigationStack(viewModel: .init(), rootItem: rootItem) { stackItem in
            Factory(stackItem: stackItem)
        }
    }
}

struct TestRootView: View {
    @EnvironmentObject var viewModel: StackViewModel
    let stackItem: StackItem

    var body: some View {
        VStack {
            Text("Root View")
        }
        .background(Color.red)
        .onAppear {
            if self.stackItem.toolbarItems.trailingItems.isEmpty == true {
                self.viewModel.appendTrailing(AnyView(self.trailingItems), self.stackItem)
            }
        }
    }

    var trailingItems: some View {
        Button(action: {
            self.viewModel.append(fakeStakItems.randomElement() ?? .init(value: "nil", toolbarItems: .init(title: "nil")))
        }) {
            Image(systemName: "plus.square")
                .toolbarImageItemStyle()
        }
    }
}

struct Factory: View {
    let stackItem: StackItem
    
    @ViewBuilder var body: some View {
        if stackItem.value is UUID {
            TestRootView(stackItem: stackItem)
        }
        if stackItem.value is Double {
            DoubleView(stackItem: stackItem)
        }
        
        if stackItem.value is Int {
            IntView(stackItem: stackItem)
        }
        
        if stackItem.value is String {
            StringView(stackItem: stackItem)
        }
    }
}

struct DoubleView: View {
    @EnvironmentObject var viewModel: StackViewModel
    let stackItem: StackItem
    
    var body: some View {
        VStack {
            Text(verbatim: "Double: \(stackItem.value)")
            Button(action: {
                self.stackItem.toolbarItems.setTitle(title: "Modified title")
            }) {
                Text("CHnage title to: Modified title")
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(Color.pink.edgesIgnoringSafeArea(.all))
        .onAppear {
            if self.stackItem.toolbarItems.trailingItems.isEmpty {
                self.viewModel.appendTrailing(AnyView(self.trailingItems), self.stackItem)
            }
        }
    }

    var trailingItems: some View {
        Button (action: {
            self.viewModel.append(fakeStakItems.randomElement() ?? .init(value: "nil", toolbarItems: .init()))
        }) {
            Image(systemName: "plus.square")
                .toolbarImageItemStyle()
        }
    }
}

struct StringView: View {
    let stackItem: StackItem
    @EnvironmentObject var viewModel: StackViewModel
    
    var body: some View {
        VStack {
            Text(verbatim: "String: \(stackItem.value)")
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(Color.green.edgesIgnoringSafeArea(.all))
        .onAppear {
            if self.stackItem.toolbarItems.leadingItems.isEmpty {
                self.viewModel.appendLeading(AnyView(self.leadingItems), self.stackItem)
                self.viewModel.appendLeading(AnyView(self.leadingItem2), self.stackItem)
            }
            
            if self.stackItem.toolbarItems.trailingItems.isEmpty {
                self.viewModel.appendTrailing(AnyView(self.trilingItems), self.stackItem)
                self.viewModel.appendTrailing(AnyView(self.trilingItems2), self.stackItem)
            }
        }
    }

    var leadingItems: some View {
        Button(action: {
            print("Hello from toolbar")
        }) {
            Image(systemName: "speaker.3")
                .toolbarImageItemStyle()
        }
    }

    var leadingItem2: some View {
        Button(action: {
            print("Hello from toolbar")
        }) {
            Image(systemName: "table.fill")
                .toolbarImageItemStyle()
        }
    }

    var trilingItems: some View {
        Button(action: {
            print("Hello from toolbar")
        }) {
            Image(systemName: "trash")
                .toolbarImageItemStyle()
        }
    }
    
    @ViewBuilder var trilingItems2: some View {
        Button(action: {
            print("Hello from toolbar")
        }) {
            Image(systemName: "bin.xmark.fill")
                .toolbarImageItemStyle()
        }
        
        Button(action: {
            
            self.viewModel.append(fakeStakItems.randomElement() ?? .init(value: "nil", toolbarItems: .init()))
        }) {
            Image(systemName: "plus.square")
                .toolbarImageItemStyle()
        }
    }
}

struct IntView: View {
    let stackItem: StackItem
    @EnvironmentObject var viewModel: StackViewModel

    var body: some View {
        ScrollView {
            VStack {
                Text(verbatim: "Int: \(stackItem.value)")
                ForEach(1...100, id: \.self) { i in
                    Text("\(i)")
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
        }
        .background(Color.orange.edgesIgnoringSafeArea(.all))
        .onAppear {
            if self.stackItem.toolbarItems.trailingItems.isEmpty {
                self.viewModel.appendTrailing(AnyView(self.trailingItems), self.stackItem)
            }
        }
    }

    var trailingItems: some View {
        Button(action: {
            self.viewModel.append(fakeStakItems.randomElement() ?? .init(value: "nil", toolbarItems: .init()))
        }) {
            Image(systemName: "plus.square")
                .toolbarImageItemStyle()
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        IntView(stackItem: .init(value: 1))
    }
}
