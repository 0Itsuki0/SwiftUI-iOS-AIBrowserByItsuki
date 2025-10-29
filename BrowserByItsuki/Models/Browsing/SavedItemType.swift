//
//  SavedItemType.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/27.
//

import Foundation

enum SavedItemType: Identifiable, CaseIterable {
    case bookmark
    case readingList
    case history
    
    var id: String {
        return self.title
    }
    
    var iconName: String {
        switch self {
        case .bookmark:
            "book"
        case .readingList:
            "eyeglasses"
        case .history:
            "clock"
        }
    }
    
    var title: String {
        switch self {
        case .bookmark:
            "Bookmarks"
        case .readingList:
            "Reading List"
        case .history:
            "Recent"
        }
    }
}
