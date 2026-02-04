//
//  DefaultCharactersRepository.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import Foundation

final class DefaultCharactersRepository: CharactersRepositoryProtocol {
    
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func fetchCharacters(params: CharactersParameters) async throws -> CharactersPageEntity {
        let endpoint = CharactersEndpoint.list(
            page: params.page,
            name: params.name,
            status: params.status?.rawValue,
            gender: params.gender?.rawValue
        )
        
        let dto: CharactersPageDTO = try await networkClient.request(endpoint: endpoint)
        let entities: [CharacterEntity] = try dto.results.map {
            try CharacterMapper.map($0)
        }
        let nextPage = extractNextPage(from: dto.info.next)
        
        return CharactersPageEntity(items: entities, nextPage: nextPage)
    }
    
    private func extractNextPage(from nextURLString: String?) -> Int? {
        guard let nextURLString,
              let url = URL(string: nextURLString),
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let pageValue = components.queryItems?.first(where: {$0.name == "page"})?.value,
              let page = Int(pageValue) else {
            return nil
        }
        
        return page
    }
}
