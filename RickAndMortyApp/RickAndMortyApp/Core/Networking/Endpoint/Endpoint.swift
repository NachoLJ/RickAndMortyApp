//
//  Endpoint.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import Foundation

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var method: HttpMethod { get }
    var body: Data? { get }
    var headers: [String: String] { get }
}

extension Endpoint {
    var queryItems: [URLQueryItem] { [] }
    var method: HttpMethod { .get }
    var body: Data? { nil }
    var headers: [String: String] { [:] }

    var url: URL? {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.path = path
        components?.queryItems = queryItems.isEmpty ? nil : queryItems
        return components?.url
    }
}
