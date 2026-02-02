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
    
    private func debugLog(_ message: String) {
#if DEBUG
        print("🟣 [HomeVM] \(message)")
#endif
    }
    
    // MARK: - Dependencies
    private let fetchCharactersUseCase: FetchCharactersUseCaseProtocol
    
    // MARK: - State
    @Published private(set) var state = HomeViewState()
    
    // Pagination control
    private var nextPage: Int? = 1
    private var isLoadingNextPage: Bool = false
    
    // MARK: - Init
    init(fetchCharactersUseCase: FetchCharactersUseCaseProtocol) {
        self.fetchCharactersUseCase = fetchCharactersUseCase
    }
    
    // MARK: - Lifecycle
    func onAppear() {
        // Avoid reload if content is already loaded
        if case .loaded = state.content { return }
        debugLog("onAppear -> load initial characters")
        
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
    
    func loadNextPageIfNeeded(currentItemID: Int) {
        guard !isLoadingNextPage else { return }
        guard let nextPage else { return }
        guard case .loaded(let items) = state.content else { return }

        let threshold = 6
        guard let index = items.firstIndex(where: { $0.id == currentItemID }) else { return }
        let shouldLoadMore = index >= (items.count - threshold)
        guard shouldLoadMore else { return }

        debugLog("trigger load more at index \(index)/\(items.count - 1) | currentItemID=\(currentItemID) | requesting page \(nextPage)")

        // ✅ IMPORTANT: lock BEFORE starting the async task
        isLoadingNextPage = true

        Task { await loadCharactersPage(page: nextPage, append: true) }
    }
    
    // MARK: - Private
    private func loadInitialCharacters() async {
        nextPage = 1
        state.content = .loading
        isLoadingNextPage = true
        await loadCharactersPage(page: 1, append: false)
    }
    
    private func loadCharactersPage(page: Int, append: Bool) async {
        defer { isLoadingNextPage = false }

        debugLog("➡️ start request page=\(page) append=\(append)")

        do {
            let query = CharactersQuery(page: page)
            let pageResult = try await fetchCharactersUseCase.execute(query: query)

            debugLog("✅ success page=\(page) received=\(pageResult.items.count) nextPage=\(String(describing: pageResult.nextPage))")

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
                debugLog("🧩 appended -> total=\((current + newRows).count)")
            } else {
                state.content = .loaded(newRows)
                debugLog("🧩 replaced -> total=\(newRows.count)")
            }
        } catch {
            debugLog("❌ failed page=\(page) error=\(error)")
            if page == 1 {
                state.content = .error(message: "Failed to load characters. Please try again")
            }
        }
    }
}
