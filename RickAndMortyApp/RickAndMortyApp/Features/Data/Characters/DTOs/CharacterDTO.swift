//
//  CharacterDTO.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import Foundation

struct CharacterDTO: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let image: String
}
