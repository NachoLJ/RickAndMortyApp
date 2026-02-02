//
//  CharacterEntity.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import Foundation

struct CharacterEntity: Equatable, Identifiable, Sendable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let gender: CharacterGender
    let imageURL: URL
    
    init(id: Int, name: String, status: CharacterStatus, species: String, gender: CharacterGender, imageURL: URL) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.gender = gender
        self.imageURL = imageURL
    }
    
}
