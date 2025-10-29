//
//  ChatContainerView.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/29.
//

import SwiftUI
import FoundationModels

struct ChatContainerView: View {
    @Environment(BrowserManager.self) private var  browserManager

    @Binding var showChatWindow: Bool
    var focused: FocusState<Bool>.Binding
    
    private let symbolName: String = "exclamationmark.bubble"
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 24) {
            if self.showChatWindow {
                Group {
                    if let chatManager = browserManager.chatManager {
                        switch ChatManager.model.availability {
                        case .available:
                            ChatView(focused: focused)
                                .environment(chatManager)
                        
                        case .unavailable(let reason):
                            let description = switch reason {
                            case .appleIntelligenceNotEnabled:
                                "Apple Intelligence is not enabled."
                            case .deviceNotEligible:
                                "This device is not eligible for Apple Intelligence."
                            case .modelNotReady:
                                "Apple Intelligence Model is not ready."
                            @unknown default:
                                "Apple Intelligence is unavailable for Unknown reason."
                            }
                            
                            ContentUnavailableView("Chat Not Available", systemImage: symbolName, description: Text(description))

                        }
                    } else {
                        ContentUnavailableView("Chat Not Available", systemImage: symbolName)
                    }
                }
                .containerRelativeFrame([.horizontal, .vertical], { length, axis in
                    switch axis {
                    case .horizontal:
                        return length * 0.7
                    case .vertical:
                        return length * 0.55
                    }
                })
                .background(RoundedRectangle(cornerRadius: 16).fill(.gray.opacity(0.2)))
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .background(RoundedRectangle(cornerRadius: 16).fill(.clear).stroke(.gray, style: .init(lineWidth: 2)))
                .shadow(color: .gray.opacity(0.5), radius: 1, x: 0.5, y: 0.5)

            }

            Button(action: {
                withAnimation {
                    self.showChatWindow.toggle()
                }
            }, label: {
                Image(systemName: "bubble")
                    .font(.headline)
                    .foregroundStyle(.black)
            })
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 8))
            .background(RoundedRectangle(cornerRadius: 8).fill(.clear).stroke(.gray, style: .init(lineWidth: 2)))
            .opacity(self.showChatWindow ? 0.4 : 0.6)
        }
        .padding(.all, 16)
        .padding(.bottom, browserManager.openedTab == nil ? 0 : 40)
    }
}


//#Preview(body: {
//    let manager = BrowserManager()
//    VStack {
//        Text("base view")
//    }
//    .frame(maxWidth: .infinity, maxHeight: .infinity)
//    .background(.gray.opacity(0.2))
//    .overlay(alignment: .bottomTrailing, content: {
//        ChatContainerView(showChatWindow: .constant(true), focused: FocusState.init().projectedValue)
//            .environment(manager)
//    })
//})
