//
//  StartUpView.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/27.
//


import SwiftUI

struct StartUpView: View {
    @Environment(BrowserManager.self) private var browserManager
    
    var navigateTo: ((URL) -> Void)?
    var showItemsManagementSheet: ((SavedItemType) -> Void)?
    
    var body: some View {
        let recentHistories: [History] = Array(self.browserManager.histories.prefix(3))
    
        let readingList: [ReadingListItem] = Array(self.browserManager.readingItems.prefix(3))
       
        let bookmarks: [Bookmark] = Array(self.browserManager.bookmarks.prefix(3))

        ScrollView {
            LazyVStack(alignment: .leading, spacing: 32) {

                VStack(alignment: .leading, spacing: 16) {
                    title("Suggestions", onShowAllClick: nil)
                    
                    HStack(spacing: 16) {
                        ForEach(self.browserManager.suggestions, id: \.self) { suggestion in
                            if let url = URL(string: suggestion) {
                                Button(action: {
                                    self.navigateTo?(url)
                                }, label: {
                                    WebPreviewView(url: url, arrangement: .vertical)
                                })
                            }
                        }
                    }
                }
                
                if !recentHistories.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        title(SavedItemType.history.title, onShowAllClick: { self.showItemsManagementSheet?(.history)})
                        
                        HStack(spacing: 16) {
                            ForEach(recentHistories) { history in
                                Button(action: {
                                    self.navigateTo?(history.url)
                                }, label: {
                                    WebPreviewView(url: history.url, arrangement: .vertical)
                                })
                            }
                        }
                    }
                }
                
                if !readingList.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        title(SavedItemType.readingList.title, onShowAllClick: { self.showItemsManagementSheet?(.readingList)})
                        
                        VStack(spacing: 16) {
                            ForEach(readingList) { readingItem in
                                Button(action: {
                                    self.navigateTo?(readingItem.url)
                                }, label: {
                                    WebPreviewView(url: readingItem.url, arrangement: .horizontal)
                                })
                            }
                        }
                    }
                }
                
                
                if !bookmarks.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        title(SavedItemType.bookmark.title, onShowAllClick: { self.showItemsManagementSheet?(.bookmark)})
                        
                        VStack(spacing: 16) {
                            ForEach(bookmarks) { bookmark in
                                Button(action: {
                                    self.navigateTo?(bookmark.url)
                                }, label: {
                                    WebPreviewView(url: bookmark.url, arrangement: .horizontal, title: bookmark.title)
                                })
                            }
                        }
                    }
                }
                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .scrollTargetLayout()
            .tint(.black)
        }
        .contentMargins(.vertical, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray.opacity(0.2))

    }
    
    private func title(_ text: any StringProtocol, onShowAllClick: (() -> Void)? ) -> some View {
        HStack {
            Text(text)
                .fontWeight(.bold)
                .font(.title2)
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            Spacer()
            
            if let onShowAllClick {
                Button(action: {
                    onShowAllClick()
                }, label: {
                    Text("Show All")
                })
                .tint(Color.blue)
                .padding(.trailing, 4)
            }
        }
    }
}


