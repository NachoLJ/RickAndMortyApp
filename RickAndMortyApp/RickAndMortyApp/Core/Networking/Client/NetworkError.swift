//
//  NetworkError.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case networkError(Error)
    case httpError(statusCode: Int)
    case noData
    case decodingError(Error)
    case unknown
}
