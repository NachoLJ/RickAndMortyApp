//
//  CharacterRowModel.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 1/2/26.
//

import Foundation

struct CharacterRowModel: Identifiable, Hashable {
    let id: Int
    let name: String
    let statusText: String
    let speciesText: String
    let imageURL: URL?
}
