//
//  UserDefaultsKey.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/27.
//

import Foundation

enum UserDefaultsKey: String {
    case browsingHistories
    case readingItems
    case bookmarks
    case recentSearches
    case lastOpenedTab
    case tabs
    
    static let userDefaults = UserDefaults.standard
    
    private var key: String {
        return self.rawValue
    }
    
    func setValue(value: Any?) {
        Self.userDefaults.setValue(value, forKey: self.key)
    }
    
    func getValue() -> Any? {
        return Self.userDefaults.object(forKey: self.key)
    }
}
