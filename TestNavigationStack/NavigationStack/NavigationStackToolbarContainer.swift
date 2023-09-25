//
//  NavigationStackToolbarContainer.swift
//  TestSwiftUI
//
//  Created by hamed on 9/24/23.
//

import SwiftUI

struct NavigationStackToolbarContainer: View {
    @EnvironmentObject var toolbarItem: StackItemToolbar
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            HStack{
                ToolbarBackButton()
                ForEach(toolbarItem.leadingItems) { toolbarItem in
                    toolbarItem.value
                }
                Spacer()

                Spacer()
                ForEach(toolbarItem.trailingItems) { toolbarItem in
                    toolbarItem.value
                }
            }
            .padding([.leading, .trailing, .bottom], 8)
            .frame(minWidth: 0, maxWidth: .infinity)
            .materialBackground(colorScheme: colorScheme)
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .overlay(alignment: .top, content: titleOverlay)
        .animation(.easeInOut, value: toolbarItem.title)
    }
    
   var titleOverlay: some View {
        HStack {
            Spacer()
            Text(toolbarItem.title ?? "")
            Spacer()
        }
    }
}

struct ToolbarBackButton: View {
    @EnvironmentObject var viewModel: StackViewModel

   @ViewBuilder var body: some View {
        if viewModel.stackItems.count > 1 {
            Button(action: {
                self.viewModel.popLast()
            }) {
                buttonTitle
            }
            .contextMenu {
                ForEach(viewModel.stackItems) { stackItem in
                    Button(action: {
                        while self.viewModel.stackItems.last != stackItem {
                            self.viewModel.popLast()
                        }
                    }) {
                        Text(stackItem.toolbarItems.title ?? "")
                    }
                }
            }
        }
    }
    
    var buttonTitle: some View {
        HStack(spacing: 0) {
            Image(systemName: backIconName)
                .toolbarImageItemStyle()
            Text(previousItem?.toolbarItems.title ?? "")
                .padding(.trailing, 6)
        }
    }
    
    var backIconName: String {
        if #available(iOS 14.0, *) {
            return "chevron.backward"
        } else {
            return "chevron.left"
        }
    }
    
    var previousItem: StackItem? {
        if let lastItemIndex = viewModel.stackItems.indices.last, viewModel.stackItems.indices.contains(lastItemIndex - 1) {
            return viewModel.stackItems[lastItemIndex - 1]
        } else {
            return nil
        }
    }
}

struct NavigationControl_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStackToolbarContainer()
    }
}
