//
//  DefaultImageCache.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 3/2/26.
//

import Foundation
import UIKit

protocol ImageCacheProtocol: Sendable {
    func image(for url: URL) -> UIImage?
    func insert(_ image: UIImage, for url: URL)
}

final class DefaultImageCache: ImageCacheProtocol {

    private let cache = NSCache<NSURL, UIImage>()

    init() {
        // Ajustes razonables (puedes tocarlos después si quieres)
        cache.countLimit = 300                 // máx nº de imágenes
        cache.totalCostLimit = 50 * 1024 * 1024 // ~50MB aproximados
    }

    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    func insert(_ image: UIImage, for url: URL) {
        // Coste aproximado para que NSCache gestione memoria mejor
        let cost = image.pngData()?.count ?? 1
        cache.setObject(image, forKey: url as NSURL, cost: cost)
    }
}
