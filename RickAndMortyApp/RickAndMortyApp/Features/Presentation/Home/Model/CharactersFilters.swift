//
//  CharactersFilters.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 4/2/26.
//

import Foundation

struct CharactersFilters: Equatable {
    var name: String?
    var status: CharacterStatus?
    var gender: CharacterGender?
    
    var isActive: Bool {
        name != nil || status != nil || gender != nil
    }
    
    var hasFilters: Bool {
        status != nil || gender != nil
    }
    
    mutating func reset() {
        name = nil
        status = nil
        gender = nil
    }
    
    mutating func resetFilters() {
        status = nil
        gender = nil
    }
    
    mutating func resetSearch() {
        name = nil
    }
}
