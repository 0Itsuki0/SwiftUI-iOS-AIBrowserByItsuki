//
//  MessageType.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/29.
//

import SwiftUI

enum MessageType: Identifiable, Equatable {
    case userPrompt(UUID, String)
    case response(UUID, String)
    
    var id: UUID {
        switch self {
        case .userPrompt(let id, _):
            return id
        case .response(let id, _):
            return id
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    var isUserMessage: Bool {
        if case .userPrompt(_, _) = self {
            return true
        }
        return false
    }
    
    var messageContent: String {
        switch self {
        case .response(_, let m):
            return m
        case .userPrompt(_, let m):
            return m
        }
    }
}
