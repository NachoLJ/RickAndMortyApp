//
//  CharacterDetailViewModelTests.swift
//  RickAndMortyAppTests
//
//  Created by Ignacio Lopez Jimenez on 4/2/26.
//

import XCTest
@testable import RickAndMortyApp

@MainActor
final class CharacterDetailViewModelTests: XCTestCase {
    
    func test_onAppear_loadsCharacterDetail_andSetsLoadedState() async {
        // Arrange
        let expectedCharacter = makeCharacterEntity(id: 1, name: "Rick Sanchez")
        let mockUseCase = MockFetchCharacterByIdUseCase(result: .success(expectedCharacter))
        let sut = CharacterDetailViewModel(characterId: 1, fetchCharacterUseCase: mockUseCase)
        
        // Act
        await sut.loadCharacter()
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1s
        
        // Assert
        if case .loaded(let character) = sut.state {
            XCTAssertEqual(character.name, "Rick Sanchez")
            XCTAssertEqual(character.id, 1)
            XCTAssertEqual(character.status, .alive)
            XCTAssertEqual(character.species, "Human")
        } else {
            XCTFail("Expected loaded state, got \(sut.state)")
        }
    }
    
    func test_onAppear_whenError_setsErrorState() async {
        // Arrange
        let mockUseCase = MockFetchCharacterByIdUseCase(result: .failure(TestError.networkFailure))
        let sut = CharacterDetailViewModel(characterId: 1, fetchCharacterUseCase: mockUseCase)
        
        // Act
        await sut.loadCharacter()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Assert
        if case .error(let message) = sut.state {
            XCTAssertFalse(message.isEmpty)
        } else {
            XCTFail("Expected error state, got \(sut.state)")
        }
    }
    
    func test_onAppear_startsWithLoadingState() {
        // Arrange
        let mockUseCase = MockFetchCharacterByIdUseCase(result: .success(makeCharacterEntity(id: 1)))
        let sut = CharacterDetailViewModel(characterId: 1, fetchCharacterUseCase: mockUseCase)
        
        // Assert - Initial state should be loading
        if case .loading = sut.state {
            // Success
        } else {
            XCTFail("Expected loading state initially, got \(sut.state)")
        }
    }
    
    func test_onAppear_passesCorrectIdToUseCase() async {
        // Arrange
        let expectedCharacter = makeCharacterEntity(id: 42)
        let mockUseCase = MockFetchCharacterByIdUseCase(result: .success(expectedCharacter))
        let sut = CharacterDetailViewModel(characterId: 42, fetchCharacterUseCase: mockUseCase)
        
        // Act
        await sut.loadCharacter()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Assert
        let receivedId = await mockUseCase.receivedId
        XCTAssertEqual(receivedId, 42)
    }
    
    func test_retry_reloadsCharacterDetail() async {
        // Arrange
        let expectedCharacter = makeCharacterEntity(id: 1, name: "Rick Sanchez")
        let mockUseCase = MockFetchCharacterByIdUseCase(result: .success(expectedCharacter))
        let sut = CharacterDetailViewModel(characterId: 1, fetchCharacterUseCase: mockUseCase)
        
        // Act
        await sut.retry()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Assert
        if case .loaded(let character) = sut.state {
            XCTAssertEqual(character.name, "Rick Sanchez")
        } else {
            XCTFail("Expected loaded state after retry")
        }
        
        let callCount = await mockUseCase.callCount
        XCTAssertEqual(callCount, 1)
    }
    
    func test_onAppear_whenAlreadyLoaded_doesNotReload() async {
        // Arrange
        let expectedCharacter = makeCharacterEntity(id: 1, name: "Rick")
        let mockUseCase = MockFetchCharacterByIdUseCase(result: .success(expectedCharacter))
        let sut = CharacterDetailViewModel(characterId: 1, fetchCharacterUseCase: mockUseCase)
        
        // First load
        await sut.loadCharacter()
        try? await Task.sleep(nanoseconds: 100_000_000)
        let firstCallCount = await mockUseCase.callCount
        
        // Act - Second loadCharacter
        await sut.loadCharacter()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Assert - Should not call use case again
        let secondCallCount = await mockUseCase.callCount
        XCTAssertEqual(firstCallCount, secondCallCount)
    }
    
    func test_characterData_mapsEntityCorrectly() async {
        // Arrange
        let character = CharacterEntity(
            id: 5,
            name: "Jerry Smith",
            status: .alive,
            species: "Human",
            gender: .male,
            origin: "Earth",
            location: "Earth",
            episodes: [1],
            imageURL: URL(string: "https://example.com/5.png")!
        )
        let mockUseCase = MockFetchCharacterByIdUseCase(result: .success(character))
        let sut = CharacterDetailViewModel(characterId: 5, fetchCharacterUseCase: mockUseCase)
        
        // Act
        await sut.loadCharacter()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Assert
        if case .loaded(let detail) = sut.state {
            XCTAssertEqual(detail.id, 5)
            XCTAssertEqual(detail.name, "Jerry Smith")
            XCTAssertEqual(detail.status, .alive)
            XCTAssertEqual(detail.species, "Human")
            XCTAssertEqual(detail.gender, .male)
            XCTAssertEqual(detail.imageURL, URL(string: "https://example.com/5.png")!)
        } else {
            XCTFail("Expected loaded state with mapped data")
        }
    }
}

// MARK: - Test Helpers

private extension CharacterDetailViewModelTests {
    func makeCharacterEntity(
        id: Int,
        name: String = "Test Character",
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
            episodes: [1],
            imageURL: URL(string: "https://example.com/\(id).png")!
        )
    }
}

// MARK: - Mock UseCase

private actor MockFetchCharacterByIdUseCase: FetchCharacterByIdUseCaseProtocol {
    private let result: Result<CharacterEntity, Error>
    private(set) var callCount = 0
    private(set) var receivedId: Int?
    
    init(result: Result<CharacterEntity, Error>) {
        self.result = result
    }
    
    func execute(id: Int) async throws -> CharacterEntity {
        callCount += 1
        receivedId = id
        return try result.get()
    }
}

// MARK: - Test Error

private enum TestError: Error {
    case networkFailure
}
