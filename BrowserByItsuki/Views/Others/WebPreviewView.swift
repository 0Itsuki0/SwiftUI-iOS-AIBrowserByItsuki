//
//  WebPreviewView.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/27.
//

import SwiftUI

struct WebPreviewView: View {
    enum IconTitleArrangement {
        case horizontal
        case vertical
    }
    
    private let cacheManager: MetadataCacheManager = MetadataCacheManager.shared

    var url: URL
    var arrangement: IconTitleArrangement
    
    var iconWidth: CGFloat = 80
    var iconPadding: CGFloat = 16
    var containerPadding: CGFloat = 16
    var containerColor: Color = Color.white.opacity(0.8)
    var aspectRatio: CGFloat = 1.0
        
    @State var title: String? = nil
    @State private var image: Image? = nil
    
    
    var body: some View {
        let title = self.title ?? self.url.host() ?? "Unknown"
        Group {
            if arrangement == .horizontal {
                HStack(spacing: 16) {
                    self.icon
                    Text(title)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                }
                .padding(.all, self.containerPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 16).fill(self.containerColor))
                
            } else {
                VStack(spacing: 16) {
                    self.icon
                    Text(title)
                        .lineLimit(1)
                        .frame(width: self.iconWidth - iconWidth/5)
                        .fontWeight(.medium)

                }
            }
        }
        .task {
            let (title, uiImage) = await self.cacheManager.getMetadata(forKey: self.url)
            if self.title == nil {
                self.title = title
            }
            if let uiImage {
                self.image = Image(uiImage: uiImage)
            }
        }

    }
    
    @ViewBuilder
    private var icon: some View {
        Group {
            if let image = self.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if let firstCharacter = self.title?.first {
                Text(String("\(firstCharacter)"))
                    .foregroundStyle(.white)
                    .font(.title)
                    .fontWeight(.bold)
                
            } else {
                Image(systemName: "questionmark")
            }
        }
        .minimumScaleFactor(0.5)
        .foregroundStyle(.white)
        .font(.title)
        .fontWeight(.bold)
        .padding(.all, self.iconPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray.opacity(0.2))
        .aspectRatio(self.aspectRatio, contentMode: .fit)
        .frame(width: self.iconWidth)
        .clipShape(RoundedRectangle(cornerRadius: self.iconWidth/5))
        .shadow(color: .gray.opacity(0.5), radius: 1, x: 0.5, y: 0.5)

            
    }

}
