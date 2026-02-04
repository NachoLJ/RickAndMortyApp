//
//  CharacterDetailViewModel.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 4/2/26.
//

import Foundation
import Combine

@MainActor
final class CharacterDetailViewModel: ObservableObject {
    
    @Published private(set) var state: CharacterDetailViewState = .loading
    
    private let characterId: Int
    private let fetchCharacterUseCase: FetchCharacterByIdUseCase
    
    init(characterId: Int, fetchCharacterUseCase: FetchCharacterByIdUseCase) {
        self.characterId = characterId
        self.fetchCharacterUseCase = fetchCharacterUseCase
    }
    
    func loadCharacter() async {
        state = .loading
        
        do {
            let character = try await fetchCharacterUseCase.execute(id: characterId)
            state = .loaded(character)
        } catch let error as NetworkError {
            state = .error(message: error.localizedDescription)
        } catch {
            state = .error(message: error.localizedDescription)
        }
    }
    
    func retry() async {
        await loadCharacter()
    }
}
