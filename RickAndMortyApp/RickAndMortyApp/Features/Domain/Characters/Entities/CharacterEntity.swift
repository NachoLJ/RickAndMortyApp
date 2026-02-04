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
    let origin: String
    let location: String
    let episodes: [Int]
    let imageURL: URL
    
    init(id: Int, name: String, status: CharacterStatus, species: String, gender: CharacterGender, origin: String, location: String, episodes: [Int], imageURL: URL) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.gender = gender
        self.origin = origin
        self.location = location
        self.episodes = episodes
        self.imageURL = imageURL
    }
    
}
