//
//  CharacterDetailViewState.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 4/2/26.
//

import Foundation

enum CharacterDetailViewState: Equatable {
    case loading
    case loaded(CharacterEntity)
    case error(message: String)
}
