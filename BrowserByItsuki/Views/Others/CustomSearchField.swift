//
//  CustomSearchField.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/27.
//


import SwiftUI
import WebKit

struct CustomSearchField: View {
    @Environment(BrowserManager.self) private var browserManager

    @Binding var isSearching: Bool
    @Binding var webPage: WebPage

    @State private var searchQuery: String = ""
    @State private var searchQuerySelection: TextSelection? = nil
    @FocusState private var searchFocused

    var body: some View {
        if let tab = browserManager.openedTab {
            VStack {
                HStack(spacing: 8) {
                    HStack(spacing: 8) {
                        if isSearching {
                            TextField("", text: $searchQuery, selection: $searchQuerySelection)
                                .focused($searchFocused)
                                .keyboardType(.webSearch)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                                .textFieldStyle(.plain)
                                .onChange(of: searchFocused, {
                                    if let url = tab.currentUrl {
                                        self.searchQuery = url.absoluteString
                                    }
                                    if let range = searchQuery.firstRange(of: searchQuery) {
                                        self.searchQuerySelection = .init(range: range)
                                    } else {
                                        self.searchQuerySelection = nil
                                    }
                                })
                                .onSubmit({
                                    self.onSearchSubmit(addToRecent: true)
                                })
                            
                            Button(action: {
                                self.searchQuerySelection = nil
                                self.searchQuery = ""
                            }, label: {
                                Image(systemName: "xmark")
                            })
                            
                        } else {
                            if let url = tab.currentUrl {
                                Text(url.host() ?? url.path(percentEncoded: false))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .lineLimit(1)
                                    .overlay(alignment: .trailing, content: {
                                        Button(action: {
                                            if self.webPage.isLoading {
                                                webPage.stopLoading()
                                            } else {
                                                webPage.reload()
                                            }
                                        }, label: {
                                            Image(systemName: self.webPage.isLoading ? "xmark" : "arrow.clockwise")
                                        })
                                    })

                                
                            } else {
                                Text("Search or enter website URL")
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .lineLimit(1)
                                    .overlay(alignment: .leading, content: {
                                        Image(systemName: "magnifyingglass")
                                    })

                            }
                        }
                    }
                    .fontWeight(.medium)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .bottom, content: {
                        if self.webPage.isLoading {
                            ProgressView(value: self.webPage.estimatedProgress, total: 1.0)
                                .progressViewStyle(.linear)
                                .controlSize(.extraLarge)
                                .padding(.horizontal, 20)
                        }
                    })
                    .background(Capsule().fill(Color.gray))
                    .onTapGesture {
                        if !self.isSearching {
                            self.isSearching = true
                        }
                    }

                        
                    if searchFocused {
                        Button(action: {
                            self.isSearching = false
                        }, label: {
                            Image(systemName: "xmark")
                                .padding(.all, 4)
                        })
                        .foregroundStyle(.gray)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.circle)
                        
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity)
                .background(.clear)
                .animation(.default, value: self.isSearching)
                .onChange(of: searchFocused, {
                    // handle user dismissing the search field without the button, for example, on enter button
                    if !searchFocused {
                        isSearching = false
                        self.searchQuerySelection = nil
                        self.searchQuery = ""
                    }
                })
                .onChange(of: isSearching, {
                    if isSearching {
                        searchFocused = true
                    } else {
                        searchFocused = false
                        self.searchQuerySelection = nil
                        self.searchQuery = ""
                    }
                })

                
                if searchFocused {
                    self.searchSuggestionList
                }
            }
        }
    }
    
    private func onSearchSubmit(addToRecent: Bool) {
        self.isSearching = false
        let url: URL?
        
        var trimmed = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if let firstSlash = trimmed.split(separator: "/").first, firstSlash.split(separator: ".").count >= 2, !trimmed.starts(with: "https://"), !trimmed.starts(with: "http://") {
            trimmed = "https://\(trimmed)"
        }
       
        if searchQuery.isEmpty {
            url = URL(string: "https://www.google.com")
        } else if let components = URLComponents(string: trimmed, encodingInvalidCharacters: true) , components.scheme != nil, components.host != nil {
            url = components.url
        } else {
            if addToRecent {
                self.browserManager.addRecentSearch(searchQuery)
            }
            url = URL(string: "https://www.google.com/search?q=\(searchQuery)", encodingInvalidCharacters: true)
        }
        
        if let url = url {
            self.webPage.load(url)
        } else {
            self.webPage.load(URL(string: "https://www.google.com"))
        }
    }
    
    
    @ViewBuilder
    private var searchSuggestionList: some View {
        List {
            Section {
                if self.browserManager.recentSearches.isEmpty {
                   ContentUnavailableView("No recent searches", systemImage: "magnifyingglass", description: Text("Your recent searches will appear here."))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)

                }
                ForEach(self.browserManager.recentSearches) { query in
                    Button(action: {
                        self.searchQuery = query.searchQuery
                        self.onSearchSubmit(addToRecent: false)
                    }, label: {
                        HStack(spacing: 16, content: {
                            Image(systemName: "magnifyingglass")
                            Text(query.searchQuery)
                        })
                        .padding(.horizontal, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    })
                    .buttonStyle(.borderless)
                    .listRowBackground(Color.clear)
                    .foregroundStyle(.black.opacity(0.7))
                    
                }
            } header: {
                HStack {
                    Text("Recent Searches")

                    Spacer()
                    
                    if !self.browserManager.recentSearches.isEmpty {
                        Button(action: {
                            self.browserManager.removeRecentSearches(self.browserManager.recentSearches)
                        }, label: {
                            Text("Clear All")
                                .foregroundStyle(.gray)
                                .fontWeight(.medium)
                        })
                        .buttonStyle(.borderless)

                    }
                }
            }
        }
        .listStyle(.plain)

    }
}

