//
//  ToolResponse.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/29.
//

import SwiftUI
import FoundationModels

@Generable
struct ToolResponse {
    
    @Guide(description: "Whether if the tool use is successful or not.")
    var success: Bool
    
    @Guide(description: "If any error occur, the error's description.")
    var error: String?
    
    @Guide(description: "Tool execution result if success.")
    var result: String?
}
