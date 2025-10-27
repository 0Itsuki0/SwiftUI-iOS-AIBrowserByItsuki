//
//  ItemsManagementSheetView.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/26.
//


import SwiftUI

struct ItemsManagementSheetView: View {
    @Environment(BrowserManager.self) private var browserManager
    @Environment(\.dismiss) private var dismiss
    
    @State var selectedItemType: SavedItemType = .history
    
    var navigateTo: ((URL) -> Void)?

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        return formatter
    }
    
    private let iconWidth: CGFloat = 40
    private let iconPadding: CGFloat = 4
    private let containerPadding: CGFloat = 0
    private let containerBackground: Color = .clear
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker(selection: $selectedItemType, content: {
                        ForEach(SavedItemType.allCases, content: { item in
                            Image(systemName: item.iconName)
                                .tag(item)
                        })
                    }, label: {})
                    .pickerStyle(.segmented)
                    .listRowBackground(Color.clear)
                }
                
                switch self.selectedItemType {
                case .bookmark:
                    bookmarksView(self.browserManager.bookmarks)
                    
                case .readingList:
                    readingListView(self.browserManager.readingItems)

                case .history:
                    historyView(self.browserManager.histories)
                }

            }
            .contentMargins(.top, 8)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        self.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                    })
                })
            })
            .tint(.black)

        }
    }
    
    
    @ViewBuilder
    private func bookmarksView(_ bookmarks: [Bookmark]) -> some View {
        if bookmarks.isEmpty {
            ContentUnavailableView("No Bookmarks", systemImage: SavedItemType.bookmark.iconName)
                .listRowBackground(Color.clear)
        } else {
            Section(SavedItemType.bookmark.title) {
                ForEach(bookmarks) { bookmark in
                    navigationButton(url: bookmark.url, title: bookmark.title)
                }
                .onDelete(perform: { indexSet in
                    let deleteItems: [Bookmark] = indexSet.map({bookmarks[$0]})
                    self.browserManager.removeBookmarks(deleteItems)
                })
            }
        }
    }
    
    @ViewBuilder
    private func readingListView(_ readingList: [ReadingListItem]) -> some View {
        if readingList.isEmpty {
            ContentUnavailableView("No Reading List Items", systemImage: "eyeglasses.slash")
                .listRowBackground(Color.clear)
        } else {
            Section(SavedItemType.readingList.title) {
                ForEach(readingList) { readingListItem in
                    navigationButton(url: readingListItem.url, title: nil)
                }
                .onDelete(perform: { indexSet in
                    let deleteItems: [ReadingListItem] = indexSet.map({readingList[$0]})
                    self.browserManager.removeReadingListItems(deleteItems)
                })
            }
        }
    }
    
    @ViewBuilder
    private func historyView(_ histories: [History]) -> some View {
        if histories.isEmpty {
            ContentUnavailableView("No Browsing History", systemImage: SavedItemType.history.iconName)
                .listRowBackground(Color.clear)
        } else {
            let groupedByDate: [DateComponents : [History]] = Dictionary(grouping: histories) { item in
                item.visitedDate.dateIdentifier
            }
                
            let keys = Array(groupedByDate.keys).sorted(by: {($0.date ?? Date()) > ($1.date ?? Date()) })

            ForEach(keys, id: \.self) { dateComponent in
                let histories: [History] = groupedByDate[dateComponent] ?? []
                let date = dateComponent.date ?? histories.first?.visitedDate
                if let date, !histories.isEmpty {
                    Section(dateFormatter.string(from: date)) {
                        ForEach(histories) { history in
                            navigationButton(url: history.url, title: nil)
                        }
                        .onDelete(perform: { indexSet in
                            let deleteItems: [History] = indexSet.map({histories[$0]})
                            self.browserManager.removeHistories(deleteItems)
                        })
                    }

                }
            }
        }
    }
    
    
    private func navigationButton(url: URL, title: String?) -> some View {
        Button(action: {
            self.navigateTo?(url)
            self.dismiss()
        }, label: {
            WebPreviewView(url: url, arrangement: .horizontal, iconWidth: self.iconWidth, iconPadding: self.iconPadding,containerPadding: self.containerPadding,containerColor: self.containerBackground, title: title)
        })
    }

}

#Preview {
    ItemsManagementSheetView()
        .environment(BrowserManager())
}
