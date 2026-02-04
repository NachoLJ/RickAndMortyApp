//
//  CharactersFilters.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 4/2/26.
//

import Foundation

struct CharactersFilters: Equatable {
    var status: CharacterStatus?
    var gender: CharacterGender?
    
    var isActive: Bool {
        status != nil || gender != nil
    }
    
    mutating func reset() {
        status = nil
        gender = nil
    }
}
