//
//  MockGenreRepository.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 16/04/2025.
//

import Foundation
@testable import MyMovies

// MARK: - MockGenreRepository
final class MockGenreRepository: GenreRepositoryProtocol {
    var didCallFetchGenres: Bool = false
    var didCallSaveGenres: Bool = false
    
    var capturedProvider: String?
    var capturedGenres: [GenreProtocol]?
    
    var fetchGenresShouldReturnError: Bool = false
    var saveGenresShouldReturnError: Bool = false
    
    var stubbedGenres: [MockGenre] = []
    
    // MARK: - GenreRepositoryProtocol
    func fetchGenres<T: GenreProtocol>(provider: String) throws -> [T] {
        didCallFetchGenres = true
        capturedProvider = provider
        
        if fetchGenresShouldReturnError {
            throw NSError(domain: "fetchGenres Error", code: 0, userInfo: nil)
        } else {
            return stubbedGenres as! [T]
        }
    }

    func saveGenres<T: GenreProtocol>(_ genres: [T], provider: String, completion: @escaping (Result<Void, Error>) -> Void) {
        didCallSaveGenres = true
        capturedProvider = provider
        capturedGenres = genres
        
        if saveGenresShouldReturnError {
            completion(.failure(NSError(domain: "saveGenres Error", code: 0, userInfo: nil)))
        } else {
            completion(.success(Void()))
        }
    }
}
