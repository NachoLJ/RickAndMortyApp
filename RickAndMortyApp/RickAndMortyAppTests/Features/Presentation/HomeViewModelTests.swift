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
    
    // MARK: - Initial Load Tests
    
    func test_onAppear_loadsCharacters_andSetsLoadedState() async {
        // Arrange
        let mockCharacters = [
            makeCharacterEntity(id: 1, name: "Rick"),
            makeCharacterEntity(id: 2, name: "Morty")
        ]
        let pageEntity = CharactersPageEntity(items: mockCharacters, nextPage: 2)
        let mockUseCase = MockFetchCharactersUseCase(result: .success(pageEntity))
        let mockRouter = MockRouter()
        let sut = HomeViewModel(fetchCharactersUseCase: mockUseCase, router: mockRouter)
        
        // Act
        sut.onAppear()
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1s
        
        // Assert
        if case .loaded(let items) = sut.state.content {
            XCTAssertEqual(items.count, 2)
            XCTAssertEqual(items[0].name, "Rick")
            XCTAssertEqual(items[1].name, "Morty")
        } else {
            XCTFail("Expected loaded state, got \(sut.state.content)")
        }
    }
    
    func test_onAppear_whenError_setsErrorState() async {
        // Arrange
        let mockUseCase = MockFetchCharactersUseCase(result: .failure(TestError.networkFailure))
        let mockRouter = MockRouter()
        let sut = HomeViewModel(fetchCharactersUseCase: mockUseCase, router: mockRouter)
        
        // Act
        sut.onAppear()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Assert
        if case .error(let message) = sut.state.content {
            XCTAssertFalse(message.isEmpty)
        } else {
            XCTFail("Expected error state, got \(sut.state.content)")
        }
    }
    
    // MARK: - Filter Tests
    
    func test_applyFilters_reloadsWithFilters() async {
        // Arrange
        let mockCharacters = [makeCharacterEntity(id: 1, name: "Rick", status: .alive)]
        let pageEntity = CharactersPageEntity(items: mockCharacters, nextPage: nil)
        let mockUseCase = MockFetchCharactersUseCase(result: .success(pageEntity))
        let mockRouter = MockRouter()
        let sut = HomeViewModel(fetchCharactersUseCase: mockUseCase, router: mockRouter)
        
        sut.filters.status = .alive
        sut.filters.gender = .male
        
        // Act
        sut.applyFilters()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Assert
        let lastParams = await mockUseCase.lastParameters
        XCTAssertEqual(lastParams?.status, .alive)
        XCTAssertEqual(lastParams?.gender, .male)
    }
    
    // MARK: - Search Tests
    
    func test_onSearchSubmit_reloadsWithNameFilter() async {
        // Arrange
        let mockCharacters = [makeCharacterEntity(id: 1, name: "Rick")]
        let pageEntity = CharactersPageEntity(items: mockCharacters, nextPage: nil)
        let mockUseCase = MockFetchCharactersUseCase(result: .success(pageEntity))
        let mockRouter = MockRouter()
        let sut = HomeViewModel(fetchCharactersUseCase: mockUseCase, router: mockRouter)
        
        sut.filters.name = "Rick"
        
        // Act
        sut.onSearchSubmit()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Assert
        let lastParams = await mockUseCase.lastParameters
        XCTAssertEqual(lastParams?.name, "Rick")
    }
    
    func test_onSearchClear_clearsNameAndReloads() async {
        // Arrange
        let mockCharacters = [makeCharacterEntity(id: 1, name: "Rick")]
        let pageEntity = CharactersPageEntity(items: mockCharacters, nextPage: nil)
        let mockUseCase = MockFetchCharactersUseCase(result: .success(pageEntity))
        let mockRouter = MockRouter()
        let sut = HomeViewModel(fetchCharactersUseCase: mockUseCase, router: mockRouter)
        
        sut.filters.name = "Rick"
        sut.filters.status = CharacterStatus.alive // Should keep this
        
        // Act
        sut.onSearchClear()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Assert
        XCTAssertNil(sut.filters.name)
        XCTAssertEqual(sut.filters.status, CharacterStatus.alive) // Should not clear other filters
        
        let lastParams = await mockUseCase.lastParameters
        XCTAssertNil(lastParams?.name)
        XCTAssertEqual(lastParams?.status, CharacterStatus.alive)
    }
    
    // MARK: - Empty State Tests
    
    func test_when404WithActiveFilters_setsEmptyState() async {
        let mockRouter = MockRouter()
        let sut = HomeViewModel(fetchCharactersUseCase: mockUseCase, router: mockRouter)
        
        sut.filters.name = "NonExistent"
        
        // Act
        sut.onAppear()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Assert
        if case .empty = sut.state.content {
            // Success
        } else {
            XCTFail("Expected empty state with empty result + active filters, got \(sut.state.content)")
        }
    }
    
    func test_whenEmptyResultWithoutFilters_setsLoadedState() async {
        // Arrange
        let pageEntity = CharactersPageEntity(items: [], nextPage: nil)
        sut.loadNextPageIfNeeded(currentItemID: items[0].id)
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Assert
        if case .loaded(let allItems) = sut.state.content {
            XCTAssertEqual(allItems.count, 2)
            XCTAssertEqual(allItems[0].name, "Rick")
            XCTAssertEqual(allItems[1].name, "Morty")
        } else {
            XCTFail("Expected loaded state with appended items")
        }
    }
    
    // MARK: - Navigation Tests
    
    func test_didSelectCharacter_pushesDetailRoute() {
        // Arrange
        let mockUseCase = MockFetchCharactersUseCase(result: .success(CharactersPageEntity(items: [], nextPage: nil)))
        let mockRouter = MockRouter()
        let sut = HomeViewModel(fetchCharactersUseCase: mockUseCase, router: mockRouter)
        
        // Act
        sut.didSelectCharacter(id: 42)
        
        // Assert
        XCTAssertEqual(mockRouter.lastPushedRoute, .characterDetail(id: 42))
    }
    
    // MARK: - Retry Tests
    
    func test_retry_reloadsCharacters() async {
        // Arrange
        let mockCharacters = [makeCharacterEntity(id: 1, name: "Rick")]
        let pageEntity = CharactersPageEntity(items: mockCharacters, nextPage: nil)
        let mockUseCase = MockFetchCharactersUseCase(result: .success(pageEntity))
        let mockRouter = MockRouter()
        let sut = HomeViewModel(fetchCharactersUseCase: mockUseCase, router: mockRouter)
        
        // Act
        sut.retry()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Assert
        if case .loaded(let items) = sut.state.content {
            XCTAssertEqual(items.count, 1)
        } else {
            XCTFail("Expected loaded state after retry")
        }
    }
}

// MARK: - Test Helpers

private extension HomeViewModelTests {
    func execute(params: CharactersParameters) async throws -> CharactersPageEntity {
        callCount += 1
        lastParameters = params
        
        let result = results[min(currentIndex, results.count - 1)]
        currentIndex += 1
        
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

// MARK: - Test Error

private enum TestError: Error {
    case networkFailure
}
