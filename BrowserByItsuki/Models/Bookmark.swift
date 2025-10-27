//
//  Bookmark.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/27.
//

import Foundation

struct Bookmark: Equatable, Identifiable, Codable {
    var id: UUID
    var title: String
    var url: URL
}


extension Bookmark {
    static var testData: [Bookmark] = [
        .init(id: UUID(), title: "Apple", url: URL(string: "https://developer.apple.com/documentation")!),
        .init(id: UUID(), title: "Google", url: URL(string: "https://www.google.com")!),
    ]
}
