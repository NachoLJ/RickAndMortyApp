//
//  CharacterStatus.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import Foundation

enum CharacterStatus: String, Equatable, CaseIterable, Sendable {
    case alive
    case dead
    case unknown
}
