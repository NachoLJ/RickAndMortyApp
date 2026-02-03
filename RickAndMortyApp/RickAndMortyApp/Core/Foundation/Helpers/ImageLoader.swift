//
//  ImageLoader.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 3/2/26.
//

import Foundation
import UIKit
import Combine

@MainActor
final class ImageLoader: ObservableObject {

    enum State: Equatable {
        case idle
        case loading
        case success(UIImage)
        case failure
    }

    @Published private(set) var state: State = .idle

    private let cache: ImageCacheProtocol
    private var task: Task<Void, Never>?

    init(cache: ImageCacheProtocol = DefaultImageCache()) {
        self.cache = cache
    }

    func load(from url: URL?) {
        guard let url else {
            state = .failure
            return
        }

        // 1) Cache hit
        if let cached = cache.image(for: url) {
            state = .success(cached)
            return
        }

        // 2) Evita lanzar múltiples descargas si se llama varias veces
        if case .loading = state { return }

        state = .loading

        task = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data) else {
                    state = .failure
                    return
                }

                cache.insert(image, for: url)
                state = .success(image)
            } catch {
                state = .failure
            }
        }
    }

    func cancel() {
        task?.cancel()
        task = nil
    }
}
