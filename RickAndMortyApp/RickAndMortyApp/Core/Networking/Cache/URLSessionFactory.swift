//
//  URLSessionFactory.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import Foundation

/// Factory for creating URLSession with aggressive caching configuration
enum URLSessionFactory {
    
    /// Creates URLSession with 50MB memory + 200MB disk cache
    /// - Returns: Configured URLSession that checks cache before making network requests
    static func makeCachedSession() -> URLSession {
        let config = URLSessionConfiguration.default
        
        /// Configure HTTP cache: 50 MB in memory + 200 MB on disk
        let memoryCapacity = 50 * 1024 * 1024 // 50 MB
        let diskCapacity = 200 * 1024 * 1024 // 200 MB
        
        config.urlCache = URLCache(
            memoryCapacity: memoryCapacity,
            diskCapacity: diskCapacity,
            diskPath: "rickandmorty-url-cache"
        )
        
        /// Return cached data when available, otherwise fetch from network
        config.requestCachePolicy = .returnCacheDataElseLoad
        
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        
        return URLSession(configuration: config)
    }
}
