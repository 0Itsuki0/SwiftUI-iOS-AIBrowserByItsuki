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
        .init(id: UUID(), title: "My GitHub", url: URL(string: "https://github.com/0Itsuki0/SwiftUI-iOS-BrowserByItsuki")!),
        .init(id: UUID(), title: "My Blog", url: URL(string: "https://medium.com/@itsuki.enjoy")!),
    ]
}
