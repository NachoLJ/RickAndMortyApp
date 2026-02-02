//
//  CharactersEndpoint.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import Foundation

struct CharactersEndpoint: Endpoint {
    
    let path: String = "/api/character"
    let method: HttpMethod = .get
    
    let queryItems: [URLQueryItem]
    
    init(page: Int, name: String?, status: String?, gender: String?) {
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
        
        self.queryItems = items
    }
    
    var baseURL: URL {
        URL(string: "https://rickandmortyapi.com")!
    }
    
    var body: Data? { nil }
    var headers: [String : String]? { [:] }
}
