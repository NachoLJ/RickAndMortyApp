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

    init(url: URL?, repository: ImageRepositoryProtocol) {
        self.url = url
        self.repository = repository
    }

    func load() {
        guard !isLoading else { return }
        isLoading = true
        error = nil

        guard let url = url else {
            self.isLoading = false
            self.error = URLError(.badURL)
            return
        }

        if let cached = ImageCache.shared.image(for: url) {
            self.image = cached
            self.isLoading = false
            return
        }

        task = Task { [weak self] in
            guard let self else { return }
            do {
                let data = try await repository.fetchImageData(from: url)
                if Task.isCancelled { return }
                if let uiImage = UIImage(data: data) {
                    ImageCache.shared.insert(uiImage, for: url)
                    self.image = uiImage
                } else {
                    self.error = URLError(.cannotDecodeRawData)
                }
            } catch {
                if Task.isCancelled { return }
                self.error = error
            }
            self.isLoading = false
        }
    }

    func cancel() {
        task?.cancel()
        task = nil
    }
}
