//
//  HomeViewModel.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 1/2/26.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published private(set) var state = HomeViewState()
    
    func onAppear() {
        // Avoid reload if content is already loaded
        if case .loaded = state.content { return }
        loadCharacters()
    }
    
    func didTapFilterButton() {
        state.isFilterSheetPresented = true
    }
    
    func didDismissFilterSheet() {
        state.isFilterSheetPresented = false
    }
    
    func retry() {
        loadCharacters()
    }
    
    // MARK: - Private
    
    private func loadCharacters() {
        state.content = .loading
        
        Task {
            try? await Task.sleep(nanoseconds: 700_000_000)
            
            let mock: [CharacterRowModel] = [
                .init(id: 1, name: "Rick Sanchez", statusText: "Alive", speciesText: "Human",
                      imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")),
                .init(id: 2, name: "Morty Smith", statusText: "Alive", speciesText: "Human",
                      imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/2.jpeg")),
                .init(id: 3, name: "Summer Smith", statusText: "Alive", speciesText: "Human",
                      imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/3.jpeg"))
            ]
            
            state.content = .loaded(mock)
        }
    }
}
