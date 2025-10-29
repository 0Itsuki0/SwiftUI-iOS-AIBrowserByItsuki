//
//  RecentSearch.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/27.
//

import Foundation

struct RecentSearch: Equatable, Identifiable, Codable {
    var id: UUID
    var searchedDate: Date
    var searchQuery: String
}

extension RecentSearch {
    static var testData: [RecentSearch] = [
        .init(id: UUID(), searchedDate: Date(), searchQuery: "Apple"),
        .init(id: UUID(), searchedDate: Date(), searchQuery: "swift"),
    ]
}
