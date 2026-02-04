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
        let session = URLSessionFactory.makeCachedSession()
        return DefaultNetworkClient(session: session)
    }()
    
    // MARK: - Data
    
    private lazy var charactersRepository: CharactersRepositoryProtocol = {
        DefaultCharactersRepository(networkClient: networkClient)
    }()
    
    private lazy var characterDetailRepository: CharacterDetailRepositoryProtocol = {
        DefaultCharacterDetailRepository(networkClient: networkClient)
    }()
    
    private lazy var imageRepository: ImageRepositoryProtocol = {
        DefaultImageRepository(networkClient: networkClient)
    }()
    
    // MARK: - Domain
    
    private lazy var fetchCharactersUseCase: FetchCharactersUseCaseProtocol = {
        FetchCharactersUseCase(repository: charactersRepository)
    }()
    
    private lazy var fetchCharacterByIdUseCase: FetchCharacterByIdUseCase = {
        FetchCharacterByIdUseCase(repository: characterDetailRepository)
    }()
    
    // MARK: - Presentation
    
    func makeHomeViewModel(router: Router) -> HomeViewModel {
        HomeViewModel(fetchCharactersUseCase: fetchCharactersUseCase, router: router)
    }
    
    func makeCharacterDetailViewModel(characterId: Int) -> CharacterDetailViewModel {
        CharacterDetailViewModel(
            characterId: characterId,
            fetchCharacterUseCase: fetchCharacterByIdUseCase
        )
    }

    func makeImageLoader(url: URL?) -> ImageLoader {
        ImageLoader(url: url, repository: imageRepository)
    }
}

