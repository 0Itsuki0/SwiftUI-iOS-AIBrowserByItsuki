//
//  ContentView.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(BrowserManager.self) private var browserManager
    
    var body: some View {
        NavigationStack {
            TabGridView()
                .environment(self.browserManager)
        }
    }
}

//#Preview(body: {
//    ContentView()
//        .environment(BrowserManager())
//})
