//
//  HomeViewModel.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 1/2/26.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    private let fetchCharactersUseCase: FetchCharactersUseCaseProtocol
    private let router: RouterProtocol
    
    @Published private(set) var state = HomeViewState()
    @Published var alertError: AlertError? = nil
    @Published var filters = CharactersFilters()
    
    /// Pagination control to prevent duplicate requests
    private var nextPage: Int? = 1
    private var isLoadingNextPage: Bool = false
    private var currentlyLoadingPage: Int? = nil
    
    init(fetchCharactersUseCase: FetchCharactersUseCaseProtocol, router: RouterProtocol) {
        self.fetchCharactersUseCase = fetchCharactersUseCase
        self.router = router
    }
    
    // MARK: - Lifecycle
    
    /// Loads initial character list when view appears (only if not already loaded)
    func onAppear() {
        if case .loaded = state.content { return }
        
        Task {
            await loadInitialCharacters()
        }
    }
    
    // MARK: - User Actions
    
    func retry() {
        Task {
            await loadInitialCharacters()
        }
    }
    
    func didSelectCharacter(id: Int) {
        router.push(.characterDetail(id: id))
    }
    
    func applyFilters() {
        Task {
            await loadInitialCharacters()
        }
    }
    
    func onSearchSubmit() {
        Task {
            await loadInitialCharacters()
        }
    }
    
    func onSearchClear() {
        filters.name = nil
        Task {
            await loadInitialCharacters()
        }
    }
    
    func clearAllFilters() {
        filters.reset()
        Task {
            await loadInitialCharacters()
        }
    }
    
    /// Loads next page when user scrolls near the end of the list
    func loadNextPageIfNeeded(currentItemID: Int) {
        guard !isLoadingNextPage else { return }
        guard let nextPage else { return }
        guard case .loaded(let items) = state.content else { return }
        
        /// Prevent loading the same page multiple times
        guard currentlyLoadingPage != nextPage else { return }
        
        let threshold = 6
        guard let index = items.firstIndex(where: { $0.id == currentItemID }) else { return }
        let shouldLoadMore = index >= (items.count - threshold)
        guard shouldLoadMore else { return }
        
        print("[HomeVM] Requesting page \(nextPage)")
        
        /// Lock both flags BEFORE starting the async task to prevent race conditions
        isLoadingNextPage = true
        currentlyLoadingPage = nextPage
        
        Task { await loadCharactersPage(page: nextPage, append: true) }
    }
    
    // MARK: - Private Methods
    
    /// Resets pagination and loads first page of characters
    private func loadInitialCharacters() async {
        nextPage = 1
        state.content = .loading
        isLoadingNextPage = true
        await loadCharactersPage(page: 1, append: false)
    }
    
    /// Fetches a specific page and either replaces or appends results
    private func loadCharactersPage(page: Int, append: Bool) async {
        defer {
            isLoadingNextPage = false
            currentlyLoadingPage = nil
        }
        
        do {
            let params = CharactersParameters(
                page: page,
                name: filters.name,
                status: filters.status,
                gender: filters.gender
            )
            let pageResult = try await fetchCharactersUseCase.execute(params: params)
            
            let newRows = pageResult.items.map { entity in
                CharacterRowModel(
                    id: entity.id,
                    name: entity.name,
                    statusText: entity.status.rawValue.capitalized,
                    speciesText: entity.species,
                    imageURL: entity.imageURL
                )
            }
            
            nextPage = pageResult.nextPage
            
            if append, case .loaded(let current) = state.content {
                state.content = .loaded(current + newRows)
            } else {
                // Empty results with active filters = empty state
                if newRows.isEmpty && filters.isActive {
                    state.content = .empty
                } else {
                    state.content = .loaded(newRows)
                }
            }
        } catch {
            /// API returns 404 when filters match nothing = empty state, not error
            if let networkError = error as? NetworkError,
               case .httpError(statusCode: 404) = networkError,
               filters.isActive {
                state.content = .empty
                return
            }
            
            if page == 1 {
                state.content = .error(message: "Failed to load characters. Please try again")
            } else {
                handleError(error, forPage: page)
            }
        }
    }
    
    private func handleError(_ error: Error, forPage page: Int) {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .networkError(let error):
                if let urlError = error as? URLError {
                    if urlError.code == .notConnectedToInternet ||
                        urlError.code == .networkConnectionLost ||
                        urlError.code == .timedOut {
                        alertError = AlertError(
                            title: "Connection Error",
                            message: "Lost in the multiverse! Check your internet connection."
                        )
                    }
                }
            case .httpError(statusCode: let code) where code != 429:
                if code >= 500 {
                    alertError = AlertError(
                        title: "Server Error",
                        message: "The Citadel servers are temporarily down. Please try again later."
                    )
                }
            default:
                break
            }
        }
    }
}
