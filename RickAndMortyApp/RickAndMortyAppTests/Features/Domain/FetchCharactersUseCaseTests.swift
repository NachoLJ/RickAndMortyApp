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
                    origin: "Earth",
                    location: "Earth",
                    episodes: [1],
                    imageURL: URL(string: "https://example.com/1.png")!
                )
            ],
            nextPage: 2
        )

        let fakeRepo = FakeCharactersRepository(result: .success(expected))
        let sut = FetchCharactersUseCase(repository: fakeRepo)
        let params = CharactersParameters(page: 1)

        // Act
        let page = try await sut.execute(params: params)

        // Assert
        XCTAssertEqual(page, expected)
        let received = await fakeRepo.receivedParameters()
        XCTAssertEqual(received, [params])
    }

    func test_execute_propagatesError() async {
        // Arrange
        let fakeError = TestError.someFailure
        let fakeRepo = FakeCharactersRepository(result: .failure(fakeError))
        let sut = FetchCharactersUseCase(repository: fakeRepo)

        // Act + Assert
        do {
            _ = try await sut.execute(params: CharactersParameters(page: 1))
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? TestError, fakeError)
        }
    }
}

// MARK: - Test Doubles

private actor FakeCharactersRepository: CharactersRepositoryProtocol {

    private let result: Result<CharactersPageEntity, Error>
    private var parameters: [CharactersParameters] = []

    init(result: Result<CharactersPageEntity, Error>) {
        self.result = result
    }

    func fetchCharacters(params: CharactersParameters) async throws -> CharactersPageEntity {
        parameters.append(params)
        return try result.get()
    }

    func receivedParameters() -> [CharactersParameters] {
        parameters
    }
}

private enum TestError: Error, Equatable {
    case someFailure
}
