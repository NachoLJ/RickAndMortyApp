//
//  ImageLoader.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 3/2/26.
//

import Foundation
import Combine
import UIKit

@MainActor
final class ImageLoader: ObservableObject {
    @Published private(set) var image: UIImage?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?

    private let url: URL?
    private let repository: ImageRepositoryProtocol
    private var task: Task<Void, Never>?
    private var retryCount = 0
    private let maxRetries = 3

    init(url: URL?, repository: ImageRepositoryProtocol) {
        self.url = url
        self.repository = repository
    }

    func load() {
        guard !isLoading else { return }
        performLoad()
    }
    
    /// Loads image from cache or network with retry on 429 errors
    private func performLoad() {
        isLoading = true
        error = nil

        guard let url = url else {
            self.isLoading = false
            self.error = URLError(.badURL)
            return
        }

        /// Check cache first for instant display
        if let cached = ImageCache.shared.image(for: url) {
            self.image = cached
            self.isLoading = false
            self.retryCount = 0
            return
        }

        task = Task { [weak self] in
            guard let self else { return }
            do {
                let data = try await repository.fetchImageData(from: url)
                if Task.isCancelled { return }
                if let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        ImageCache.shared.insert(uiImage, for: url)
                        self.image = uiImage
                        self.isLoading = false
                        self.retryCount = 0
                    }
                } else {
                    await MainActor.run {
                        self.error = URLError(.cannotDecodeRawData)
                        self.isLoading = false
                    }
                }
            } catch let error as NetworkError {
                if Task.isCancelled { return }
                
                /// Retry with exponential backoff for rate limit errors
                /// Delays: 3s, 6s, 12s (formula: 3 * 2^(retry-1))
                if case .httpError(statusCode: 429) = error, self.retryCount < self.maxRetries {
                    await MainActor.run {
                        self.retryCount += 1
                    }
                    let currentRetry = await MainActor.run { self.retryCount }
                    let delay = Double(3 * (1 << (currentRetry - 1)))
                    
                    #if DEBUG
                    print("⏳ [ImageLoader] 429 detected, retry \(currentRetry)/\(self.maxRetries) in \(delay)s for \(url.lastPathComponent)")
                    #endif
                    
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    if Task.isCancelled { return }
                    
                    await MainActor.run {
                        self.performLoad()
                    }
                    return
                }
                
                await MainActor.run {
                    self.error = error
                    self.isLoading = false
                }
            } catch {
                if Task.isCancelled { return }
                await MainActor.run {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }

    func cancel() {
        task?.cancel()
        task = nil
        isLoading = false
        retryCount = 0
    }
}
