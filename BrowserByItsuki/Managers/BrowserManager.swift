//
//  BrowserManager.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/27.
//

import SwiftUI

@Observable
class BrowserManager {
    let suggestions: [String] = ["https://www.google.com", "https://www.apple.com"]
    
    private(set) var tabs: [BrowserTab] = [] {
        didSet {
            self.saveTabs()
        }
    }
     
    var openedTab: BrowserTab? {
        didSet {
            self.saveOpenedTab()
        }
    }
    
    private(set) var histories: [History] = [] {
        didSet {
            if let data = try? self.encoder.encode(self.histories) {
                UserDefaultsKey.browsingHistories.setValue(value: data)
            }
        }
    }
    
    private(set) var recentSearches: [RecentSearch] = [] {
        didSet {
            if let data = try? self.encoder.encode(self.recentSearches) {
                UserDefaultsKey.recentSearches.setValue(value: data)
            }
        }
    }
    
    private(set) var readingItems: [ReadingListItem] = [] {
        didSet {
            if let data = try? self.encoder.encode(self.readingItems) {
                UserDefaultsKey.readingItems.setValue(value: data)
            }
        }
    }
    
    private(set) var bookmarks: [Bookmark] = [] {
        didSet {
            if let data = try? self.encoder.encode(self.bookmarks) {
                UserDefaultsKey.bookmarks.setValue(value: data)
            }
        }
    }
    
    private let encoder: JSONEncoder = JSONEncoder()
    private let decoder: JSONDecoder = JSONDecoder()

    init() {
        self.loadSavedUserDefaults()
    }
    
    func addNavigationHistory(_ url: URL) {
        self.histories.insert(History(id: UUID(), url: url, visitedDate: Date()), at: 0)
    }
    
    func addRecentSearch(_ searchQuery: String) {
        guard !searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        self.recentSearches.insert(RecentSearch(id: UUID(), searchedDate: Date(), searchQuery: searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)), at: 0)
    }
    
    func addBookmark(_ url: URL, title: String) {
        self.bookmarks.insert(Bookmark(id: UUID(), title: title, url: url), at: 0)
    }
    
    func addReadingListItem(_ url: URL) {
        self.readingItems.insert(ReadingListItem(id: UUID(), url: url), at: 0)
    }
    
    func updateSavedTab(_ tab: BrowserTab) {
        if self.tabs.contains(where: {$0.id == tab.id}) {
            self.saveTabs()
        }
        
        if self.openedTab?.id == tab.id {
            self.saveOpenedTab()
        }
    }

    func removeTab(_ tab: BrowserTab) {
        self.tabs.removeAll(where: { $0.id == tab.id })
    }
    
    func removeTabs(_ tabs: [BrowserTab]) {
        self.tabs.removeAll(where: { tabs.contains($0) })
    }
    
    func removeHistories(_ histories: [History]) {
        self.histories.removeAll(where: {histories.contains($0)})
    }
    
    func removeBookmarks(_ bookmarks: [Bookmark]) {
        self.bookmarks.removeAll(where: {bookmarks.contains($0)})
    }
    
    func removeReadingListItems(_ readingListItem: [ReadingListItem]) {
        self.readingItems.removeAll(where: {readingListItem.contains($0)})
    }

    func removeRecentSearches(_ searches: [RecentSearch]) {
        self.recentSearches.removeAll(where: {searches.contains($0)})
    }
    
    func openNewTab(_ url: URL?) {
        let tab = BrowserTab(url: url)
        self.tabs.append(tab)
        self.openedTab = tab
    }

}


// MARK: Private Helpers
extension BrowserManager {
    
    private func loadSavedUserDefaults() {
        if let data = UserDefaultsKey.bookmarks.getValue() as? Data {
            self.bookmarks = (try? self.decoder.decode([Bookmark].self, from: data)) ?? []
        }
        
        if let data = UserDefaultsKey.browsingHistories.getValue() as? Data {
            self.histories = ((try? self.decoder.decode([History].self, from: data)) ?? []).sorted(by: {$0.visitedDate > $1.visitedDate})
        }
        
        if let data = UserDefaultsKey.tabs.getValue() as? Data {
            self.tabs = (try? self.decoder.decode([BrowserTab].self, from: data)) ?? []
        }

        
        if let data = UserDefaultsKey.lastOpenedTab.getValue() as? Data {
            let openedTab = try? self.decoder.decode(BrowserTab?.self, from: data)
            
            if let tab = self.tabs.first(where: {$0.id == openedTab?.id}) {
                self.openedTab = tab
            } else if let tab = openedTab {
                self.tabs.append(tab)
                self.openedTab = tab
            } else {
                self.openedTab = nil
            }
        }
        
        
        if let data = UserDefaultsKey.readingItems.getValue() as? Data {
            self.readingItems = (try? self.decoder.decode([ReadingListItem].self, from: data)) ?? []
        }
        
        if let data = UserDefaultsKey.recentSearches.getValue() as? Data {
            self.recentSearches = ((try? self.decoder.decode([RecentSearch].self, from: data)) ?? []).sorted(by: {$0.searchedDate > $1.searchedDate})
        }
    }

    private func saveTabs() {
        if let data = try? self.encoder.encode(tabs) {
            UserDefaultsKey.tabs.setValue(value: data)
        }
    }
    
    private func saveOpenedTab() {
        if let openedTab = self.openedTab, let data = try? self.encoder.encode(openedTab) {
            UserDefaultsKey.lastOpenedTab.setValue(value: data)
        } else {
            UserDefaultsKey.lastOpenedTab.setValue(value: nil)
        }
    }
    
}
