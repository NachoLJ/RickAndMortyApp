//
//  CharactersPageEntity.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import Foundation

struct CharactersPageEntity: Equatable, Sendable {
    let items: [CharacterEntity]
    let nextPage: Int?
}
