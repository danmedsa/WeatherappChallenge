//
//  Cache.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import UIKit

protocol Caching {
    var fileManager: FileManaging { get }
    func cachedImage(from url: URL) -> Data?
    func cacheImage(_ data: Data, from url: URL)
}

extension Caching {
    func cachedImage(from url: URL) -> Data? {
        guard let imageName = imageName(from: url),
              let imageURL = cachesDirectory()?.appendingPathComponent(imageName),
              let data = fileManager.contents(atPath: imageURL.path) else { return nil }

        return data
    }
    
    func cacheImage(_ data: Data, from url: URL) {
        guard let imageName = imageName(from: url),
              let imageURL = cachesDirectory(create: true)?.appendingPathComponent(imageName) else { return }
        
        fileManager.createFile(atPath: imageURL.path, contents: data, attributes: nil)
    }
    
    private func cachesDirectory(create shouldCreate: Bool = false) -> URL? {
        return try? fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: shouldCreate)
    }
    
    private func imageName(from url: URL) -> String? {
        let components = url.absoluteString.components(separatedBy: "/")
        return components.first(where: { $0.lowercased().contains(".png") })
    }
}
