//
//  TabThumbnailView.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/27.
//

import SwiftUI
import WebKit

struct TabThumbnailView: View {
    @Environment(BrowserManager.self) private var browserManager

    var tab: BrowserTab
    
    @State private var webPage = WebPage(configuration: .defaultConfiguration)
    @State private var loaded: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            Group {
                if let url = tab.currentUrl {
                    WebView(webPage)
                        .onAppear {
                            guard !loaded || webPage.url != url else { return }
                            webPage.load(url)
                            self.loaded = true
                        }
                        .overlay(content: {
                            Rectangle()
                                .fill(Color.clear)
                                .contentShape(Rectangle())
                        })

                } else {
                    StartUpView()
                }
            }
            .disabled(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(0.75, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .gray.opacity(0.5), radius: 1, x: 0.5, y: 0.5)
            .contextMenu {
                Button(action: {
                    withAnimation {
                        self.browserManager.openNewTab(self.tab.currentUrl)
                    }
                }, label: {
                    Image(systemName: "plus.square.on.square")
                    Text("Duplicate Tab")
                })
                
                Button(role: .destructive, action: {
                    withAnimation {
                        self.browserManager.openNewTab(self.tab.currentUrl)
                    }
                }, label: {
                    Image(systemName: "xmark")
                    Text("Close Tab")
                })
                
                Divider()
                
                Button(role: .destructive, action: {
                    let tabs = self.browserManager.tabs.filter({$0 != self.tab})
                    withAnimation {
                        self.browserManager.removeTabs(tabs)
                    }
                }, label: {
                    Image(systemName: "xmark")
                    Text("Close Other Tabs")
                })
                
            }

            
            Group {
                if let url = tab.currentUrl {
                    Text(tab.title ?? url.host() ?? "Unknown")
                } else {
                    Text("Start Page")
                }
            }
            .lineLimit(1)
            .fontWeight(.medium)

        }
        .overlay(alignment: .topTrailing, content: {
            Button(action: {
                withAnimation {
                    self.browserManager.removeTab(tab)
                }
            }, label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12))
                    .foregroundStyle(.white)
                    .fontWeight(.medium)
            })
            .padding(.all, 8)
            .buttonStyle(.borderless)
            .background(Circle().fill(.gray.opacity(0.8)))
            .padding(.horizontal, 4)
            .padding(.vertical, 8)
            .foregroundStyle(.white)
        })
        
    }
}

#Preview {
    TabThumbnailView( tab: .init(url: nil))
        .environment(BrowserManager())
        .frame(width: 160)
}
