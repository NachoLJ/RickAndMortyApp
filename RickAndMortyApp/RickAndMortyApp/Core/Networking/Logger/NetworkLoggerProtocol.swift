//
//  NetworkLoggerProtocol.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 3/2/26.
//

import Foundation
import os

protocol NetworkLoggerProtocol: Sendable {
    func logRequest(_ request: URLRequest)
    func logResponse(_ response: HTTPURLResponse, dataSize: Int, durationMs: Int, url: URL)
    func logError(_ error: Error, url: URL, durationMs: Int)
}

struct NetworkLogger: NetworkLoggerProtocol {

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "RickAndMortyApp",
                                category: "Network")

    func logRequest(_ request: URLRequest) {
        #if DEBUG
        let method = request.httpMethod ?? "GET"
        let url = request.url?.absoluteString ?? "nil"
        logger.info("➡️ \(method) \(url)")
        #endif
    }

    func logResponse(_ response: HTTPURLResponse, dataSize: Int, durationMs: Int, url: URL) {
        #if DEBUG
        let status = response.statusCode
        let cacheControl = response.value(forHTTPHeaderField: "Cache-Control") ?? "-"
        let age = response.value(forHTTPHeaderField: "Age") ?? "-"
        let cfCache = response.value(forHTTPHeaderField: "CF-Cache-Status") ?? "-"
        logger.info("✅ \(status) \(url.absoluteString) (\(durationMs)ms, \(dataSize) bytes) | cache-control=\(cacheControl) age=\(age) cf=\(cfCache)")
        #endif
    }

    func logError(_ error: Error, url: URL, durationMs: Int) {
        #if DEBUG
        logger.error("❌ \(url.absoluteString) (\(durationMs)ms) error=\(String(describing: error))")
        #endif
    }
}
