//
//  FetchCharactersUseCase.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import Foundation

protocol FetchCharactersUseCaseProtocol: Sendable {
    func execute(params: CharactersParameters) async throws -> CharactersPageEntity
}

/// Fetches paginated characters list with optional filters
struct FetchCharactersUseCase: FetchCharactersUseCaseProtocol {
    private let repository: CharactersRepositoryProtocol
    
    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(params: CharactersParameters) async throws -> CharactersPageEntity {
        try await repository.fetchCharacters(params: params)
    }
}
