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
    
    // MARK: - Dependencies
    private let fetchCharactersUseCase: FetchCharactersUseCaseProtocol
    
    // MARK: - State
    @Published private(set) var state = HomeViewState()
    
    // MARK: - Init
    init(fetchCharactersUseCase: FetchCharactersUseCaseProtocol) {
        self.fetchCharactersUseCase = fetchCharactersUseCase
    }
    
    // MARK: - Lifecycle
    func onAppear() {
        // Avoid reload if content is already loaded
        if case .loaded = state.content { return }
        Task {
            await loadInitialCharacters()
        }
    }
    
    // MARK: - UI Actions
    func retry() {
        Task {
            await loadInitialCharacters()
        }
    }
    
    // MARK: - Private
    private func loadInitialCharacters() async {
        state.content = .loading
        
        do {
            let query = CharactersQuery(page: 1)
            let page = try await fetchCharactersUseCase.execute(query: query)
            
            let rows = page.items.map { entity in
                CharacterRowModel(
                    id: entity.id,
                    name: entity.name,
                    statusText: entity.status.rawValue.capitalized,
                    speciesText: entity.species,
                    imageURL: entity.imageURL
                )
            }
            
            state.content = .loaded(rows)
        } catch {
            state.content = .error(message: "Failed to load characters. Please try again")
        }
    }
}
