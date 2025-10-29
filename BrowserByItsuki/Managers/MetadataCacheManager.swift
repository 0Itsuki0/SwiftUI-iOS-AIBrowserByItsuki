//
//  MetadataCacheManager.swift
//  BrowserByItsuki
//
//  Created by Itsuki on 2025/10/27.
//

import SwiftUI
import LinkPresentation
import UniformTypeIdentifiers

actor MetadataCacheManager {
    static let shared = MetadataCacheManager()
    
    private let titleCache = NSCache<NSString, NSString>()
    private let imageCache = NSCache<NSString, UIImage>()
    
    private var loadingKeys: Set<NSString> = []

    private init() { }
    
    func getMetadata(forKey url: URL) async -> (String?, UIImage?) {
        let key = (url.host() ?? url.absoluteString) as NSString
        
        while self.loadingKeys.contains(key) {
            try? await Task.sleep(for: .microseconds(50))
            if !self.loadingKeys.contains(key) {
                break
            }
        }
        
        var title: String? = nil
        var image: UIImage? = nil
        
        if let cachedTitle = titleCache.object(forKey: key), let cachedImage = imageCache.object(forKey: key) {
            return (cachedTitle as String, cachedImage)
        }
        
        self.loadingKeys.insert(key)
        defer {
            self.loadingKeys.remove(key)
        }

        guard let metadata = await self.loadMetadata(url) else { return (nil, nil) }
        title = metadata.title
        
        if let _image = await self.getImage(metadata.iconProvider) {
            image = _image
        } else if let _image = await self.getImage(metadata.imageProvider) {
            image = _image
        } 

        if let title, let image {
            titleCache.setObject(title as NSString, forKey: key)
            imageCache.setObject(image, forKey: key)
        }
        
        return (title, image)
    }
    
    private func loadMetadata(_ url: URL) async -> LPLinkMetadata? {
        let metadataProvider = LPMetadataProvider()
        return try? await metadataProvider.startFetchingMetadata(for: url)
    }
    
    private func getImage(_ itemProvider: NSItemProvider?) async -> UIImage? {
        guard let itemProvider else { return nil }
        let allowedType = UTType.image.identifier
        guard itemProvider.hasItemConformingToTypeIdentifier(allowedType)  else { return nil }
        guard let item =  try? await itemProvider.loadItem(forTypeIdentifier: allowedType) else { return nil }
        if let url = item as? URL, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            return image
        }
        
        if let image = item as? UIImage {
            return image
        }
        
        if let data = item as? Data, let image = UIImage(data: data) {
            return image
        }
        
        return nil
    }

}

