//
//  BrowserByItsukiApp.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/25.
//

import SwiftUI

@main
struct BrowserByItsukiApp: App {
    @State private var browserManager: BrowserManager = BrowserManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(self.browserManager)
//                .onOpenURL(perform: { url in
//                    withAnimation {
//                        self.browserManager.openNewTab(url)
//                    }
//                })
//                .onTapGesture {
//                    withAnimation {
//                        browserManager.showChatWindow = false
//                    }
//                }
//                .overlay(alignment: .bottomTrailing, content: {
//                    ChatContainerView()
//                        .environment(browserManager)
//                })
//                .scrollDismissesKeyboard(.immediately)
        }
    }
}
