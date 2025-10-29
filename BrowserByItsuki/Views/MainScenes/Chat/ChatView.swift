//
//  ChatView.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/29.
//

import SwiftUI

struct ChatView: View {
    @Environment(ChatManager.self) private var chatManager
    var focused: FocusState<Bool>.Binding

    @State private var entry: String = ""
    @State private var scrollPosition: ScrollPosition = .init()
    
    @State private var entryHeight: CGFloat = 24
    
    private let streamingMessageID = UUID()

    var body: some View {
        ScrollViewReader { proxy in
            List {
                Section(content: {

                    ForEach(chatManager.messages) { message in
                        let isUser: Bool = message.isUserMessage
                        let messageContent: String = message.messageContent
                        self.messageView(messageContent, isUser: isUser)
                            .id(message.id)

                    }
                    
                    if let message = chatManager.streamingMessage {
                        self.messageView(message.isEmpty || message == "null" ? "..." : message, isUser: false)
                            .id(streamingMessageID)
                    }

                }, header: {
                    VStack(alignment: .leading) {
                        HStack(alignment: .bottom) {
                            Text("Chat With AI")
                                .font(.headline)
                                .padding(.top, 8)

                            Spacer()
                            
                            Button(action: {
                                chatManager.clearChat()
                            }, label: {
                                Text("Clear")
                                    .foregroundStyle(.gray)
                                    .fontWeight(.medium)

                            })
                            .buttonStyle(.borderless)
                            .disabled(chatManager.messages.isEmpty)
                        }
                        
                        if chatManager.messages.isEmpty {
                            ContentUnavailableView("No Message", systemImage: "character.bubble", description: Text("Enter some messages to start."))
                                .scaleEffect(x: 0.8, y: 0.8)
                        }
                        
                        if let error = chatManager.error {
                            Text(String("\(error)"))
                                .foregroundStyle(.red)
                                .fontWeight(.medium)
                        }
                    }
    
                })
                .listSectionMargins(.vertical, 0)
                .listSectionMargins(.horizontal, 8)


            }
            .contentMargins(.top, 0)
            .scrollTargetLayout()
            .scrollPosition($scrollPosition, anchor: .bottom)
            .defaultScrollAnchor(.bottom, for: .alignment)
            .defaultScrollAnchor(.bottom, for: .initialOffset)
            .scrollContentBackground(.hidden)
            .background(.gray.opacity(0.05))
            .onChange(of: chatManager.messages, initial: true, {
                if let last = chatManager.messages.last {
                    proxy.scrollTo(last.id, anchor: .bottom)
                }
            })
            .onChange(of: chatManager.streamingMessage, initial: true, {
                guard chatManager.streamingMessage != nil else {
                    return
                }
                proxy.scrollTo(self.streamingMessageID, anchor: .bottom)
            })
        }
        .safeAreaInset(edge: .bottom, content: {
            HStack(spacing: 12) {
                TextField("", text: $entry, axis: .vertical)
                    .focused(focused)
                    .onSubmit({
                        self.sendPrompt()
                    })
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray, style: .init(lineWidth: 1))
                        .fill(.white.opacity(0.8))
                    )
                
                Button(action: {
                    self.sendPrompt()
                }, label: {
                    Image(systemName: "paperplane.fill")
                })
                .disabled(chatManager.isResponding)
                
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .background(.gray.opacity(0.5))
            .background(.white)
        })
        .foregroundStyle(.black.opacity(0.8))
        .onTapGesture(perform:  {
            self.focused.wrappedValue = false
        })

    }
    
    @ViewBuilder
    private func messageView(_ text: String, isUser: Bool) -> some View {
        Text(text)
            .listRowBackground(Color.clear)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(RoundedRectangle(cornerRadius: 8).fill(isUser ? .yellow.opacity(0.3) : .green.opacity(0.3)))
            .padding(isUser ? .leading: .trailing, 64)
            .padding(.vertical, 8)
            .listRowInsets(.vertical, 0)
            .listRowInsets(.horizontal, 8)
            .listRowSeparator(.hidden)

    }

    
    private func sendPrompt() {
        self.focused.wrappedValue = false
        let entry = self.entry.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !entry.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        guard !chatManager.isResponding else {
            return
        }
        
        self.entry = ""

        Task {
            await chatManager.respond(to: entry)
        }
    }
}
