//
//  FetchCharacterByIdUseCaseTests.swift
//  RickAndMortyAppTests
//
//  Created by Ignacio Lopez Jimenez on 4/2/26.
//

import XCTest
@testable import RickAndMortyApp

final class FetchCharacterByIdUseCaseTests: XCTestCase {
    
    func test_execute_returnsCharacterFromRepository() async throws {
        // Arrange
        let expectedCharacter = CharacterEntity(
            id: 1,
            name: "Rick Sanchez",
            status: .alive,
            species: "Human",
            gender: .male,
            origin: "Earth",
            location: "Earth",
            episodes: [1, 2, 3],
            imageURL: URL(string: "https://example.com/1.png")!
        )
        
        let mockRepo = MockCharacterDetailRepository(result: .success(expectedCharacter))
        let sut = FetchCharacterByIdUseCase(repository: mockRepo)
        
        // Act
        let character = try await sut.execute(id: 1)
        
        // Assert
        XCTAssertEqual(character.id, expectedCharacter.id)
        XCTAssertEqual(character.name, expectedCharacter.name)
        XCTAssertEqual(character.status, expectedCharacter.status)
        
        let receivedId = await mockRepo.receivedId
        XCTAssertEqual(receivedId, 1)
    }
    
    func test_execute_propagatesRepositoryError() async {
        // Arrange
        let expectedError = TestError.notFound
        let mockRepo = MockCharacterDetailRepository(result: .failure(expectedError))
        let sut = FetchCharacterByIdUseCase(repository: mockRepo)
        
        // Act + Assert
        do {
            _ = try await sut.execute(id: 999)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? TestError, expectedError)
        }
    }
    
    func test_execute_passesCorrectIdToRepository() async throws {
        // Arrange
        let character = CharacterEntity(
            id: 42,
            name: "Morty",
            status: .alive,
            species: "Human",
            gender: .male,
            origin: "Earth",
            location: "Earth",
            episodes: [1],
            imageURL: URL(string: "https://example.com/42.png")!
        )
        
        let mockRepo = MockCharacterDetailRepository(result: .success(character))
        let sut = FetchCharacterByIdUseCase(repository: mockRepo)
        
        // Act
        _ = try await sut.execute(id: 42)
        
        // Assert
        let receivedId = await mockRepo.receivedId
        XCTAssertEqual(receivedId, 42)
    }
}

// MARK: - Test Doubles

private actor MockCharacterDetailRepository: CharacterDetailRepositoryProtocol {
    
    private let result: Result<CharacterEntity, Error>
    private(set) var receivedId: Int?
    
    init(result: Result<CharacterEntity, Error>) {
        self.result = result
    }
    
    func fetchCharacter(id: Int) async throws -> CharacterEntity {
        receivedId = id
        return try result.get()
    }
}

private enum TestError: Error, Equatable {
    case notFound
}
