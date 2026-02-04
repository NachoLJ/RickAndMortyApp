//
//  CharactersParameters.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import Foundation

struct CharactersParameters: Equatable, Sendable {
    var page: Int
    var name: String?
    var status: CharacterStatus?
    var gender: CharacterGender?
    var sort: CharactersSort?
    
    init(
        page: Int = 1,
        name: String? = nil,
        status: CharacterStatus? = nil,
        gender: CharacterGender? = nil,
        sort: CharactersSort? = nil
    ) {
        self.page = page
        self.name = name
        self.status = status
        self.gender = gender
        self.sort = sort
    }
}
