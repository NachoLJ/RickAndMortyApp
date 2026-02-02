//
//  CharactersPageDTO.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import Foundation

struct CharactersPageDTO: Decodable {
    let info: PageInfoDTO
    let results: [CharacterDTO]
}

struct PageInfoDTO: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
