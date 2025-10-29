//
//  WebNavigationTool.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/29.
//

import SwiftUI
import FoundationModels

struct WebNavigationTool: Tool {
        
    var navigateTo: @Sendable (URL) async -> Void
    
    let name = "WebNavigation"
    let description = "Help user navigate to a web with a given URL."
    
    
    @Generable
    struct Arguments {
        @Guide(description: "Full URL string to navigate to. Ex: `https://www.google.com`.")
        let url: String
    }

    func call(arguments: Arguments) async throws -> ToolResponse {
        #if DEBUG
        print("navigation: \(arguments.url)")
        #endif
        
        guard let url = URL(string: arguments.url) else {
            return ToolResponse(success: false, error: "Invalid URL.")
        }
        await self.navigateTo(url)
        return ToolResponse(success: true, result: "Navigated to \(arguments.url) with success. Tell the user that the navigation is finished.")
    }
}
