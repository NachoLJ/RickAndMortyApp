//
//  ImageCache.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 3/2/26.
//

import Foundation
import UIKit

/// In-memory image cache with size limits
final class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSURL, UIImage>()
    
    private init() {
        cache.countLimit = 500
        cache.totalCostLimit = 100 * 1024 * 1024
    }
    
    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    func insert(_ image: UIImage, for url: URL) {
        let cost = image.pngData()?.count ?? 0
        cache.setObject(image, forKey: url as NSURL, cost: cost)
    }
}
