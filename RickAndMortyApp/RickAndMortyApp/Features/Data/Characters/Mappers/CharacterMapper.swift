//
//  CharacterMapper.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import Foundation

enum CharacterMapper {
    
    static func map(_ dto: CharacterDTO) throws -> CharacterEntity {
        guard let url = URL(string: dto.image) else {
            throw MappingError.invalidURL(dto.image)
        }
        
        return CharacterEntity(
            id: dto.id,
            name: dto.name,
            status: mapStatus(dto.status),
            species: dto.species,
            gender: mapGender(dto.gender),
            imageURL: url
        )
    }
    
    private static func mapStatus(_ value: String) -> CharacterStatus {
        switch value.lowercased() {
        case "alive": return .alive
        case "dead": return .dead
        default: return .unknown
        }
    }
    
    private static func mapGender(_ value: String) -> CharacterGender {
        switch value.lowercased() {
        case "male": return .male
        case "female": return .female
        case "genderless": return .genderless
        default: return .unknown
        }
    }
    
    enum MappingError: Error, Equatable {
        case invalidURL(String)
    }
    
}
