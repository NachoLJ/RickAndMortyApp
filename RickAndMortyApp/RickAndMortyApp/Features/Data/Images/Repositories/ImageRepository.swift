//
//  ImageRepository.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 3/2/26.
//

import Foundation

protocol ImageRepositoryProtocol: Sendable {
    func fetchImageData(from url: URL) async throws -> Data
}

final class DefaultImageRepository: ImageRepositoryProtocol {

    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func fetchImageData(from url: URL) async throws -> Data {
        // Delegate to network client so we keep logging and shared session/cache behavior
        return try await networkClient.fetchImage(from: url)
    }
}
