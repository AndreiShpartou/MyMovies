//
//  APICache.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 15/03/2025.
//

import Foundation

// A lightweight in-memory cache for raw API responses.
final class APICache {
    static let shared = APICache()

    private let cache = NSCache<NSString, CacheItem>()
    private let defaultTTL: TimeInterval = 60 * 60 // Time-to-live 1 hour
    private let maxMemorySize: Int = 50 * 1024 * 1024 // 50 MB

    private init() {
        cache.totalCostLimit = maxMemorySize
    }

    // Store raw data for a given key
    func store(_ data: Data, for key: String, ttl: TimeInterval? = nil) {
        let item = CacheItem(
            data: data,
            dateInserted: Date(),
            ttl: ttl ?? defaultTTL
        )

        cache.setObject(item, forKey: key as NSString)
    }

    // Retrieve the cached Data if not expired, otherwise returns nil.
    func retrieve(for key: String) -> Data? {
        guard let item = cache.object(forKey: key as NSString) else {
            return nil
        }

        // Check if expired
        let elapsed = Date().timeIntervalSince(item.dateInserted)
        if elapsed > item.ttl {
            // Invalidate
            cache.removeObject(forKey: key as NSString)

            return nil
        }

        return item.data
    }
}

// A wrapper for cached data + metadata
final class CacheItem: NSObject {
    let data: Data
    let dateInserted: Date
    let ttl: TimeInterval

    init(data: Data, dateInserted: Date, ttl: TimeInterval) {
        self.data = data
        self.dateInserted = dateInserted
        self.ttl = ttl
    }
}
