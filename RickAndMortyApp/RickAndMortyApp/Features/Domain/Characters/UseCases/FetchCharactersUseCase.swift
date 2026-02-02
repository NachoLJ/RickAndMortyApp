//
//  FetchCharactersUseCase.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import Foundation

protocol FetchCharactersUseCaseProtocol: Sendable {
    func execute(query: CharactersQuery) async throws -> CharactersPageEntity
}

struct FetchCharactersUseCase: FetchCharactersUseCaseProtocol {
    
    private let repository: CharactersRepositoryProtocol
    
    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(query: CharactersQuery) async throws -> CharactersPageEntity {
        try await repository.fetchCharacters(query: query)
    }
}
