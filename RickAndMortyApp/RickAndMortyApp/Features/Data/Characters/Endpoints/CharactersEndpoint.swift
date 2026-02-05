//
//  CharactersEndpoint.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import Foundation

/// Defines API endpoints for characters
enum CharactersEndpoint: Endpoint {
    /// Paginated character list with optional filters (name, status, gender)
    case list(page: Int, name: String?, status: String?, gender: String?)
    /// Single character by ID
    case character(id: Int)
    
    var path: String {
        switch self {
        case .list:
            return "/api/character"
        case .character(let id):
            return "/api/character/\(id)"
        }
    }
    
    var method: HttpMethod { .get }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .list(let page, let name, let status, let gender):
            return makeListQueryItems(page: page, name: name, status: status, gender: gender)
        case .character:
            return []
        }
    }
    
    var baseURL: URL {
        URL(string: "https://rickandmortyapi.com")!
    }
    
    /// Builds query parameters for list endpoint, omitting empty filters
    private func makeListQueryItems(page: Int, name: String?, status: String?, gender: String?) -> [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "page", value: String(page))
        ]
        
        if let name, !name.isEmpty {
            items.append(URLQueryItem(name: "name", value: name))
        }
        
        if let status, !status.isEmpty {
            items.append(URLQueryItem(name: "status", value: status))
        }
        
        if let gender, !gender.isEmpty {
            items.append(URLQueryItem(name: "gender", value: gender))
        }
        
        return items
    }
    
    var body: Data? { nil }
    var headers: [String : String]? { [:] }
}
