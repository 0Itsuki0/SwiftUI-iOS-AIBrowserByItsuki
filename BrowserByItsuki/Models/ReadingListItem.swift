//
//  ReadingListItem.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/27.
//


import Foundation

struct ReadingListItem: Equatable, Identifiable, Codable {
    var id: UUID
    var url: URL
}

extension ReadingListItem {
    static var testData: [ReadingListItem] = [
        .init(id: UUID(), url: URL(string: "https://developer.apple.com/documentation")!),
        .init(id: UUID(), url: URL(string: "https://developer.apple.com/documentation")!),
        .init(id: UUID(), url: URL(string: "https://developer.apple.com/documentation")!),
    ]
}
