//
//  URLSessionFactory.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import Foundation

enum URLSessionFactory {
    
    static func makeCachedSession() -> URLSession {
        let config = URLSessionConfiguration.default
        
        // Cache: memory + disk
        let memoryCapacity = 50 * 1024 * 1024 // 50 MB
        let diskCapacity = 200 * 1024 * 1024 // 200 MB
        
        config.urlCache = URLCache(
            memoryCapacity: memoryCapacity,
            diskCapacity: diskCapacity,
            diskPath: "rickandmorty-url-cache"
        )
        
        // Prefer cached data when available, otherwise load.
        // This helps reduce requests and avoid rate limiting
        config.requestCachePolicy = .returnCacheDataElseLoad
        
        // Optional but helpful: timeouts
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        
        return URLSession(configuration: config)
    }
}
