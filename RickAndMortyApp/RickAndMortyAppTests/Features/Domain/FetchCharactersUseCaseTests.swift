//
//  FetchCharactersUseCaseTests.swift
//  RickAndMortyAppTests
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import XCTest
@testable import RickAndMortyApp

final class FetchCharactersUseCaseTests: XCTestCase {

    func test_execute_returnsRepositoryResult() async throws {
        // Arrange
        let expected = CharactersPageEntity(
            items: [
                CharacterEntity(
                    id: 1,
                    name: "Rick",
                    status: .alive,
                    species: "Human",
                    gender: .male,
                    imageURL: URL(string: "https://example.com/1.png")!
                )
            ],
            nextPage: 2
        )

        let fakeRepo = FakeCharactersRepository(result: .success(expected))
        let sut = FetchCharactersUseCase(repository: fakeRepo)
        let query = CharactersQuery(page: 1)

        // Act
        let page = try await sut.execute(query: query)

        // Assert
        XCTAssertEqual(page, expected)
        let received = await fakeRepo.receivedQueries()
        XCTAssertEqual(received, [query])
    }

    func test_execute_propagatesError() async {
        // Arrange
        let fakeError = TestError.someFailure
        let fakeRepo = FakeCharactersRepository(result: .failure(fakeError))
        let sut = FetchCharactersUseCase(repository: fakeRepo)

        // Act + Assert
        do {
            _ = try await sut.execute(query: CharactersQuery(page: 1))
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? TestError, fakeError)
        }
    }
}

// MARK: - Test Doubles

private actor FakeCharactersRepository: CharactersRepositoryProtocol {

    private let result: Result<CharactersPageEntity, Error>
    private var queries: [CharactersQuery] = []

    init(result: Result<CharactersPageEntity, Error>) {
        self.result = result
    }

    func fetchCharacters(query: CharactersQuery) async throws -> CharactersPageEntity {
        queries.append(query)
        return try result.get()
    }

    func receivedQueries() -> [CharactersQuery] {
        queries
    }
}

private enum TestError: Error, Equatable {
    case someFailure
}
