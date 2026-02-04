//
//  CharacterDetailRepository.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 4/2/26.
//

import Foundation

protocol CharacterDetailRepositoryProtocol: Sendable {
    func fetchCharacter(id: Int) async throws -> CharacterEntity
}

final class DefaultCharacterDetailRepository: CharacterDetailRepositoryProtocol {
    
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func fetchCharacter(id: Int) async throws -> CharacterEntity {
        let endpoint = CharactersEndpoint.character(id: id)
        let dto: CharacterDTO = try await networkClient.request(endpoint: endpoint)
        return try CharacterMapper.map(dto)
    }
}
