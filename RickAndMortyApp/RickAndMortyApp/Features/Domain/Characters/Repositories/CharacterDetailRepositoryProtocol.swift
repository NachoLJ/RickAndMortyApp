//
//  CharacterDetailRepositoryProtocol.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 4/2/26.
//

import Foundation

protocol CharacterDetailRepositoryProtocol: Sendable {
    func fetchCharacter(id: Int) async throws -> CharacterEntity
}
