//
//  FetchCharacterByIdUseCase.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 4/2/26.
//

import Foundation

protocol FetchCharacterByIdUseCaseProtocol: Sendable {
    func execute(id: Int) async throws -> CharacterEntity
}

struct FetchCharacterByIdUseCase: FetchCharacterByIdUseCaseProtocol {
    private let repository: CharacterDetailRepositoryProtocol
    
    init(repository: CharacterDetailRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: Int) async throws -> CharacterEntity {
        try await repository.fetchCharacter(id: id)
    }
}
