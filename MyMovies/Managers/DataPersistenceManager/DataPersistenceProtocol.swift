//
//  DataPersistenceProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 15/11/2024.
//

import Foundation

protocol DataPersistenceProtocol {
    func saveSearchQuery(_ query: String)
    func fetchRecentlySearchedMovies() -> [MovieProtocol]
}
