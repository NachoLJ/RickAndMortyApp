//
//  NetworkClient.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import Foundation

protocol NetworkClientProtocol: Sendable {
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T
    func fetchImage(from url: URL) async throws -> Data
}

final class DefaultNetworkClient: NetworkClientProtocol {

    private let session: URLSession
    private let decoder: JSONDecoder
    private let logger: NetworkLoggerProtocol

    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        logger: NetworkLoggerProtocol = NetworkLogger()
    ) {
        self.session = session
        self.decoder = decoder
        self.logger = logger
    }

    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        let urlRequest = try makeURLRequest(from: endpoint)
        let (data, _) = try await perform(urlRequest)

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }

    func fetchImage(from url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, _) = try await perform(request)
        return data
    }
}

// MARK: - Private Methods

private extension DefaultNetworkClient {

    func makeURLRequest(from endpoint: Endpoint) throws -> URLRequest {
        guard let url = endpoint.url else {
            throw NetworkError.invalidUrl
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        endpoint.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let body = endpoint.body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return request
    }

    func perform(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let url = request.url ?? URL(string: "about:blank")!

        logger.logRequest(request)

        let start = Date()
        do {
            let (data, response) = try await session.data(for: request)
            let durationMs = Int(Date().timeIntervalSince(start) * 1000)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }

            logger.logResponse(httpResponse, dataSize: data.count, durationMs: durationMs, url: url)

            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.httpError(statusCode: httpResponse.statusCode)
            }

            guard !data.isEmpty else {
                throw NetworkError.noData
            }

            return (data, httpResponse)

        } catch let error as NetworkError {
            let durationMs = Int(Date().timeIntervalSince(start) * 1000)
            logger.logError(error, url: url, durationMs: durationMs)
            throw error

        } catch {
            let durationMs = Int(Date().timeIntervalSince(start) * 1000)
            logger.logError(error, url: url, durationMs: durationMs)
            throw NetworkError.networkError(error)
        }
    }
}
