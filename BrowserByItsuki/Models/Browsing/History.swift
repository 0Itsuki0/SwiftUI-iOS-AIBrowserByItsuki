//
//  History.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/27.
//

import Foundation

struct History: Equatable, Identifiable, Codable {
    var id: UUID
    var url: URL
    var visitedDate: Date
}


extension History {
    static var testData: [History] = [
        .init(id: UUID(), url: URL(string: "https://github.com/0Itsuki0/SwiftUI-iOS-BrowserByItsuki")!, visitedDate: Date().addingTimeInterval(-60*60*48)),
        .init(id: UUID(), url: URL(string: "https://developer.apple.com/documentation")!, visitedDate: Date()),
    ]
}
