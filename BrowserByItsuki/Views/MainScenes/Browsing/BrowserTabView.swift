//
//  BrowserTabView.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/27.
//

import SwiftUI
import WebKit

struct BrowserTabView: View {
    @Environment(BrowserManager.self) private var browserManager
        
    @State private var isSearching: Bool = false
    @State private var showItemManagementType: SavedItemType? = nil
    
    @State private var showBookmarkNameEntry: Bool = false
    @State private var bookmarkName: String = ""
    
    @State private var webPage = WebPage(configuration: .defaultConfiguration)
    
    var body: some View {
        
        Group {
            if let tab = browserManager.openedTab {
                if tab.currentUrl == nil {
                    
                    if !isSearching {
                        StartUpView(
                            navigateTo: { self.webPage.load($0) },
                            showItemsManagementSheet: { self.showItemManagementType = $0 }
                        )
                    }

                } else {
                    WebView(webPage)
                        .webViewBackForwardNavigationGestures(.enabled)
                        .webViewLinkPreviews(.enabled)
                        .webViewTextSelection(.enabled)
                        .webViewMagnificationGestures(.enabled)
                        .webViewElementFullscreenBehavior(.enabled)
                        // to avoid webview going under safe area insets
                        .padding(.vertical, 1)
                        .onAppear {
                            webPage.load(tab.currentUrl)
                        }
                        .overlay(content: {
                            if self.webPage.isLoading {
                                ProgressView()
                                    .controlSize(.large)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.gray.opacity(0.2))
                            }
                        })
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .top, content: {
            CustomSearchField(isSearching: $isSearching, webPage: $webPage)
                .environment(self.browserManager)
        })
        .sheet(item: $showItemManagementType, content: { itemType in
            ItemsManagementSheetView(selectedItemType: itemType, navigateTo: { self.webPage.load($0) })
        })
        .sheet(isPresented: $showBookmarkNameEntry, content: {
            BookmarkNameEntryView(bookmarkName: self.webPage.title, urlString: self.webPage.url?.absoluteString ?? "", onConfirm: { name, url in
                self.browserManager.addBookmark(url, title: name)
            })
        })
        .toolbar(content: {
            self.bottomToolbarItems
        })
        .navigationBarBackButtonHidden()
        .onChange(of: webPage.url, initial: true, {
            if let url = webPage.url {
                self.browserManager.addNavigationHistory(url)
                self.browserManager.openedTab?.currentUrl = url
                if let tab = browserManager.openedTab {
                    self.browserManager.updateSavedTab(tab)
                }
            }
        })
        .onChange(of: webPage.title, initial: true, {
            self.browserManager.openedTab?.title = webPage.title
            if let tab = browserManager.openedTab {
                self.browserManager.updateSavedTab(tab)
            }
        })
        .onChange(of: self.browserManager.openedTab?.currentUrl, {
            if self.browserManager.openedTab?.currentUrl != webPage.url {
                webPage.load(self.browserManager.openedTab?.currentUrl)
            }
        })

    }
    
    
    @ToolbarContentBuilder
    private var bottomToolbarItems: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar, content: {
            Button(action: {
                if let url = self.webPage.lastBackwardDestination {
                    self.webPage.load(url)
                }
            }, label: {
                Image(systemName: "chevron.backward").frame(width: 40)
            })
            .disabled(!self.webPage.canNavigateBackward)
            
            Button(action: {
                if let url = self.webPage.firstForwardDestination {
                    self.webPage.load(url)
                }
            }, label: {
                Image(systemName: "chevron.forward").frame(width: 40)
            })
            .disabled(!self.webPage.canNavigateForward)
            
            
            Menu(content: {
                ShareLink(
                    item: self.webPage,
                    preview: SharePreview(
                        self.webPage.title,
                        image: Image(systemName: "globe")
                    ), label: {
                        Image(systemName: "square.and.arrow.up")

                        Text("Share")
                    }
                )
                
                Button(action: {
                    if let url = self.webPage.url {
                        self.browserManager.addReadingListItem(url)
                    }
                }, label: {
                    Image(systemName: SavedItemType.readingList.iconName)

                    Text("Add To Reading List")
                })

                Button(action: {
                    self.showBookmarkNameEntry = true
                }, label: {
                    Image(systemName: SavedItemType.bookmark.iconName)

                    Text("Add To Bookmarks")
                })
                
            }, label: {
                Image(systemName: "square.and.arrow.up").frame(width: 40)

            })
            .disabled(self.webPage.url == nil)


            
            Button(action: {
                self.showItemManagementType = .bookmark
            }, label: {
                Image(systemName: "book").frame(width: 40)
            })
            
            Button(action: {
                self.browserManager.openedTab = nil
            }, label: {
                Image(systemName: "square.on.square").frame(width: 40)
            })
        })

    }

}


//#Preview {
//    let manager = BrowserManager()
//    BrowserTabView()
//        .environment(manager)
//        .onAppear {
//            manager.openNewTab(URL(string: "https://medium.com/@itsuki.enjoy"))
//        }
//}
