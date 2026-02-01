//
//  HomeViewState.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 1/2/26.
//

import Foundation

struct HomeViewState: Equatable {
    
    enum Content: Equatable {
        case loading
        case loaded([CharacterRowModel])
        case error(message: String)
    }
    
    var title: String = "Characters"
    var content: Content = .loading
    var isFilterSheetPresented: Bool = false
}
