//
//  WebSearchTool.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/29.
//

import SwiftUI
import FoundationModels

struct WebSearchTool: Tool {
        
    var search: @Sendable (String) async -> String?
    
    let name = "WebSearch"
    let description = "Help user to search for contents on web."
    
    private let htmlLimit = 2000
    
    @Generable
    struct Arguments {
        @Guide(description: "The content to search on.")
        let searchQuery: String
    }

    func call(arguments: Arguments) async throws -> ToolResponse {
        #if DEBUG
        print("search: \(arguments.searchQuery)")
        #endif

        if let error = await self.search(arguments.searchQuery) {
            return ToolResponse(success: false, error: error)
        } else {
            let result = "Searched for \(arguments.searchQuery) with success and shared with the user directly. Tell the user that the search is finished."
            return ToolResponse(success: true, result: result)
        }
    }
}
