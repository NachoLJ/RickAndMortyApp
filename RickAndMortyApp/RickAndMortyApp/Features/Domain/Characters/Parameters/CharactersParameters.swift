//
//  CharactersParameters.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import Foundation

/// Parameters for character list requests with pagination and filters
struct CharactersParameters: Equatable, Sendable {
    var page: Int
    var name: String?
    var status: CharacterStatus?
    var gender: CharacterGender?
    
    init(
        page: Int = 1,
        name: String? = nil,
        status: CharacterStatus? = nil,
        gender: CharacterGender? = nil
    ) {
        self.page = page
        self.name = name
        self.status = status
        self.gender = gender
    }
}
