//
//  BrowserTab.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/27.
//

import SwiftUI

@Observable
class BrowserTab: Identifiable, Equatable, Hashable, Codable {
    var id: UUID
    
    var currentUrl: URL? = nil
    
    var title: String? = nil
    
    init(url: URL?) {
        self.currentUrl = url
        self.id = UUID()
    }
    
    enum CodingKeys: String, CodingKey {
        case _id = "id"
        case _currentUrl = "currentUrl"
        case _title = "title"
    }
}


extension BrowserTab {
    
    static func == (lhs: BrowserTab, rhs: BrowserTab) -> Bool {
        return lhs.id == rhs.id && lhs.currentUrl == rhs.currentUrl && lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}


extension BrowserTab {
    static var testData: [BrowserTab] = [
        .init(url: URL(string: "https://github.com/0Itsuki0/SwiftUI-iOS-BrowserByItsuki")),
        .init(url: nil),
    ]
}
