//
//  BrowserTabGridView.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/27.
//


import SwiftUI

struct BrowserTabGridView: View {
    
    @Environment(BrowserManager.self) private var browserManager
    
    @State private var searchQuery: String = ""
    @FocusState private var searchFocused
    @Namespace private var namespace
    
    private var tabs: [BrowserTab]  {
        let trimmed = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return self.browserManager.tabs
        }
        return self.browserManager.tabs.filter({
            $0.title?.localizedCaseInsensitiveContains(trimmed) == true ||
            $0.currentUrl?.path().localizedCaseInsensitiveContains(trimmed) == true
        })

    }

    var body: some View {
        @Bindable var browserManager = browserManager
        
        Group {
            if self.browserManager.tabs.isEmpty {
                ContentUnavailableView("No Tabs Added", systemImage: "square.slash", description: Text("Tab on the Plus button to start a new tab."))
            } else {
                ScrollView {
                    if self.tabs.isEmpty {
                        ContentUnavailableView("No Results", systemImage: "magnifyingglass")
                    } else {
                        LazyVGrid(columns: .init(repeating: .init(.adaptive(minimum: 160, maximum: 160), spacing: 24), count: 2), spacing: 32, content: {
                            ForEach(tabs, content: { tab in
                                Button(action: {
                                    browserManager.openedTab = tab
                                }, label: {
                                    TabThumbnailView(tab: tab)
                                        .matchedTransitionSource(id: tab.id, in: namespace)
                                })
                            })
                            
                        })
                        .scrollTargetLayout()
                    }
                }
                .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always))
                .searchFocused($searchFocused)
                .onSubmit(of: .search, {
                    self.searchFocused = false
                })
            }
        }
        .buttonStyle(.plain)
        .contentMargins(.vertical, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray.opacity(0.2))
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    withAnimation {
                        self.browserManager.openNewTab(nil)
                    }
                }, label: {
                    Image(systemName: "plus")
                })
            })
        })
        .navigationDestination(item: $browserManager.openedTab, destination: { tab in
            BrowserTabView()
                .environment(self.browserManager)
                .navigationTransition(.zoom(sourceID: tab.id, in: namespace))
        })
    }
}
