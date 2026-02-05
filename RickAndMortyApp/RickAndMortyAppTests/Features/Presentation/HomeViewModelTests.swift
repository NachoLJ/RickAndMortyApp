//
//  HomeViewModelTests.swift
//  RickAndMortyAppTests
//
//  Created by Ignacio Lopez Jimenez on 4/2/26.
//

import XCTest
import SwiftUI
import Combine
@testable import RickAndMortyApp

@MainActor
final class HomeViewModelTests: XCTestCase {
    
    func test_onAppear_loadsCharacters_andSetsLoadedState() async {
        let mockCharacters = [
            makeCharacterEntity(id: 1, name: "Rick"),
            makeCharacterEntity(id: 2, name: "Morty")
        ]
        let pageEntity = CharactersPageEntity(items: mockCharacters, nextPage: 2)
        let mockUseCase = MockFetchCharactersUseCase(result: .success(pageEntity))
        let mockRouter = MockRouter()
        let sut = HomeViewModel(fetchCharactersUseCase: mockUseCase, router: mockRouter)
        
        sut.onAppear()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        if case .loaded(let items) = sut.state.content {
            XCTAssertEqual(items.count, 2)
            XCTAssertEqual(items[0].name, "Rick")
            XCTAssertEqual(items[1].name, "Morty")
        } else {
            XCTFail("Expected loaded state, got \(sut.state.content)")
        }
    }
    
    func test_onAppear_whenError_setsErrorState() async {
        let mockUseCase = MockFetchCharactersUseCase(result: .failure(TestError.networkFailure))
        let mockRouter = MockRouter()
        let sut = HomeViewModel(fetchCharactersUseCase: mockUseCase, router: mockRouter)
        
        sut.onAppear()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        if case .error(let message) = sut.state.content {
            XCTAssertFalse(message.isEmpty)
        } else {
            XCTFail("Expected error state, got \(sut.state.content)")
        }
    }
    
    func test_applyFilters_reloadsWithFilters() async {
        let mockCharacters = [makeCharacterEntity(id: 1, name: "Rick", status: .alive)]
        let pageEntity = CharactersPageEntity(items: mockCharacters, nextPage: nil)
        let mockUseCase = MockFetchCharactersUseCase(result: .success(pageEntity))
        let mockRouter = MockRouter()
        let sut = HomeViewModel(fetchCharactersUseCase: mockUseCase, router: mockRouter)
        
        sut.filters.status = .alive
        sut.filters.gender = .male
        
        sut.applyFilters()
        
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        let lastParams = await mockUseCase.lastParameters
        XCTAssertEqual(lastParams?.status, .alive)
        XCTAssertEqual(lastParams?.gender, .male)
    }
    
    func test_onSearchSubmit_reloadsWithNameFilter() async {
        let mockCharacters = [makeCharacterEntity(id: 1, name: "Rick")]
        let pageEntity = CharactersPageEntity(items: mockCharacters, nextPage: nil)
        let mockUseCase = MockFetchCharactersUseCase(result: .success(pageEntity))
        let mockRouter = MockRouter()
        let sut = HomeViewModel(fetchCharactersUseCase: mockUseCase, router: mockRouter)
        
        sut.filters.name = "Rick"
        
        sut.onSearchSubmit()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        let lastParams = await mockUseCase.lastParameters
        XCTAssertEqual(lastParams?.name, "Rick")
    }
    
    func test_didSelectCharacter_pushesDetailRoute() {
        let mockUseCase = MockFetchCharactersUseCase(result: .success(CharactersPageEntity(items: [], nextPage: nil)))
        let mockRouter = MockRouter()
        let sut = HomeViewModel(fetchCharactersUseCase: mockUseCase, router: mockRouter)
        
        sut.didSelectCharacter(id: 42)
        
        XCTAssertEqual(mockRouter.lastPushedRoute, .characterDetail(id: 42))
    }
    
    func test_retry_reloadsCharacters() async {
        let mockCharacters = [makeCharacterEntity(id: 1, name: "Rick")]
        let pageEntity = CharactersPageEntity(items: mockCharacters, nextPage: nil)
        let mockUseCase = MockFetchCharactersUseCase(result: .success(pageEntity))
        let mockRouter = MockRouter()
        let sut = HomeViewModel(fetchCharactersUseCase: mockUseCase, router: mockRouter)
        
        sut.retry()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        if case .loaded(let items) = sut.state.content {
            XCTAssertEqual(items.count, 1)
        } else {
            XCTFail("Expected loaded state after retry")
        }
    }
}

// MARK: - Mock Use Case

private actor MockFetchCharactersUseCase: FetchCharactersUseCaseProtocol {
    private let result: Result<CharactersPageEntity, Error>
    private(set) var lastParameters: CharactersParameters?
    
    init(result: Result<CharactersPageEntity, Error>) {
        self.result = result
    }
    
    func execute(params: CharactersParameters) async throws -> CharactersPageEntity {
        lastParameters = params
        return try result.get()
    }
}

// MARK: - Mock Router

@MainActor
private class MockRouter: RouterProtocol {
    var lastPushedRoute: AppRoute?
    
    func push(_ route: AppRoute) {
        lastPushedRoute = route
    }
    
    func pop() {}
    func popToRoot() {}
    func replace(with route: AppRoute) {}
    func setRoot(_ route: AppRoute) {}
}

// MARK: - Test Helpers

private func makeCharacterEntity(
    id: Int,
    name: String,
    status: CharacterStatus = .alive,
    species: String = "Human",
    gender: CharacterGender = .male
) -> CharacterEntity {
    CharacterEntity(
        id: id,
        name: name,
        status: status,
        species: species,
        gender: gender,
        origin: "Earth",
        location: "Earth",
        episodes: [1, 2],
        imageURL: URL(string: "https://example.com/\(id).jpg")!
    )
}

// MARK: - Test Error

private enum TestError: Error {
    case networkFailure
}
