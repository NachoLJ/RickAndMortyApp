//
//  AppContainer.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import Foundation
import Combine

@MainActor
final class AppContainer: ObservableObject {
    
    // MARK: - Core
    
    private lazy var networkClient: NetworkClientProtocol = {
        DefaultNetworkClient()
    }()
    
    // MARK: - Data
    
    private lazy var charactersRepository: CharactersRepositoryProtocol = {
        DefaultCharactersRepository(networkClient: networkClient)
    }()
    
    // MARK: - Domain
    
    private lazy var fetchCharactersUseCase: FetchCharactersUseCaseProtocol = {
        FetchCharactersUseCase(repository: charactersRepository)
    }()
    
    // MARK: - Presentation
    
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(fetchCharactersUseCase: fetchCharactersUseCase)
    }
}
