//
//  BookmarkNameEntryView.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/27.
//


import SwiftUI

struct BookmarkNameEntryView: View {
    @Environment(\.dismiss) private var dismiss

    @State var bookmarkName: String
    @State var urlString: String
    
    var onConfirm: (String, URL) -> Void
    
    @State private var error: String? = nil
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Name")
                            .fontWeight(.medium)
                        TextField("",text: $bookmarkName)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("URL")
                            .fontWeight(.medium)
                        TextField("", text: $urlString)
                            .multilineTextAlignment(.trailing)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                }
                
                if let error {
                    Section {
                        Text(error)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.red)
                            .listRowBackground(Color.clear)
                    }
                    .listSectionMargins(.vertical, 0)
                }
                

            }
            .contentMargins(.top, 16)
            .navigationTitle("Add Bookmark")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                self.toolbarItems
            })
            .onAppear {
                self.error = nil
            }

        }
    }
    
    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading, content: {
            Button(action: {
                self.dismiss()
            }, label: {
                Image(systemName: "xmark")
            })
        })
        
        ToolbarItem(placement: .topBarTrailing, content: {
            Button(action: {
                let trimmed = self.bookmarkName.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else {
                    self.error = "Empty bookmark name"
                    return
                }
                guard let url = URL(string: self.urlString) else {
                    self.error = "Invalid URL"
                    return
                }
                
                self.error = nil
                
                self.onConfirm(trimmed, url)
                self.dismiss()
            }, label: {
                Text("Save")
            })
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.capsule)
            
        })
    }
    
}

//#Preview {
//    BookmarkNameEntryView(bookmarkName: "123", urlString: "!23", onConfirm: { _, _ in
//    })
//}
