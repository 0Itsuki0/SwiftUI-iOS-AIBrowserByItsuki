//
//  ContentView.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(BrowserManager.self) private var browserManager
    
    @State private var showChatWindow: Bool = false
    @FocusState private var focused
    
    var body: some View {
        NavigationStack {
            BrowserTabGridView()
                .environment(self.browserManager)
        }
        .onOpenURL(perform: { url in
            withAnimation {
                self.browserManager.openNewTab(url)
            }
        })
        .simultaneousGesture(TapGesture().onEnded({
            withAnimation {
                self.focused = false
                self.showChatWindow = false
            }
        }))
//        .onTapGesture {
//            withAnimation {
//                self.focused = false
//                self.showChatWindow = false
//            }
//        }
        .overlay(alignment: .bottomTrailing, content: {
            ChatContainerView(showChatWindow: $showChatWindow, focused: $focused)
                .environment(browserManager)
        })
        .scrollDismissesKeyboard(.immediately)

    }
}

//#Preview(body: {
//    ContentView()
//        .environment(BrowserManager())
//})
