//
//  CharactersRepositoryProtocol.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import Foundation

protocol CharactersRepositoryProtocol: Sendable {
    func fetchCharacters(query: CharactersQuery) async throws -> CharactersPageEntity
}
