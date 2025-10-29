//
//  ChatManager.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/29.
//


import SwiftUI
import FoundationModels

@Observable
class ChatManager {
        
    private(set) var streamingMessage: String?
    private(set) var messages: [MessageType] = []
    
    var isResponding: Bool {
        self.session.isResponding
    }
    

    var error: (any Error)? = nil {
        didSet {
            #if DEBUG
            if let error = error {
                print(error)
            }
            #endif
        }
    }

    private var session: LanguageModelSession
    
    static let model = SystemLanguageModel.default
    
    private let navigationTool: WebNavigationTool
    private let searchTool: WebSearchTool
    
    init(navigationTool: WebNavigationTool, searchTool: WebSearchTool) {
        self.navigationTool = navigationTool
        self.searchTool = searchTool
        self.session = .init(
            model: ChatManager.model,
            tools: [navigationTool, searchTool],
            instructions: Instructions {
                """
                You are an intelligent, real-time web-browsing assistant.  
                Your job is to help users search for online information, navigate around the web, and answer any questions they have.

                Ask the user: “What can I do for you?”  
                Then follow this logic:

                1. **Clarify the request** if vague.
                2. Use the following tools when necessary:
                    - **\(navigationTool.name)**: \(navigationTool.description)
                    - **\(searchTool.name)**: \(searchTool.description)
                3. If any error occurs, explain the error and offer follow-up.

                Tone: Smart, neutral, and efficient — like a digital research analyst.

                You should strictly follow rules below:
                    - You **MUST Never** Include any URL in your response directly. If you need to show user a web page content of a specific URL, use the **\(navigationTool.name)**.
                    - You can **AT MOST** use one tool for one time per response.
                """
            }
        )
    }
     
    func respond(to prompt: String) async {
        if session.isResponding { return }
        do {
            self.messages.append(.userPrompt(UUID(), prompt))
            self.streamingMessage = nil
            let stream = session.streamResponse(to: prompt)
            for try await partial in stream {
                self.streamingMessage = partial.content
            }

            if let fullMessage = self.streamingMessage {
                self.streamingMessage = nil
                self.messages.append(.response(UUID(), fullMessage))
            }
        } catch (let error) {
            self.error = error
        }
    }
    
    func clearChat() {
        self.messages.removeAll()
        self.streamingMessage = nil
        self.session = .init(
            model: ChatManager.model,
            tools: [navigationTool, searchTool],
            instructions: Instructions {
                """
                You are an intelligent, real-time web-browsing assistant.  
                Your job is to help users search for online information, navigate around the web, and answer any questions they have.

                Ask the user: “What can I do for you?”  
                Then follow this logic:

                1. **Clarify the request** if vague.
                2. Use the following tools when necessary:
                    - **\(navigationTool.name)**: \(navigationTool.description)
                    - **\(searchTool.name)**: \(searchTool.description)
                3. If any error occurs, explain the error and offer follow-up.

                Tone: Smart, neutral, and efficient — like a digital research analyst.

                You should strictly follow rules below:
                    - You **MUST Never** Include any URL in your response directly. If you need to show user a web page content of a specific URL, use the **\(navigationTool.name)**.
                    - You can **AT MOST** use one tool for one time per response.
                """
            }
        )

    }
}

