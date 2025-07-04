//
//  MockMovieRepository.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 16/04/2025.
//

import Foundation
@testable import MyMovies

// MARK: - MockMovieRepository
final class MockMovieRepository: MovieRepositoryProtocol {
    var didCallstoreMovieForList: Bool = false
    var didCallStoreMoviesForList: Bool = false
    var didCallFetchMovieByID: Bool = false
    var didCallFetchMoviesByList: Bool = false
    var didCallFetchMoviesByGenre: Bool = false
    var didCallClearMoviesForList: Bool = false
    var didCallRemoveMovieFromList: Bool = false
    
    var capturedMovie: MovieProtocol?
    var capturedMovies: [MovieProtocol]?
    var capturedGenre: GenreProtocol?
    var capturedProvider: String?
    var capturedListType: String?
    var capturedOrderIndex: Int?
    var capturedMovieID: Int?
    
    var storeMovieForListShouldReturnError: Bool = false
    var storeMoviesForListShouldReturnError: Bool = false
    var fetchMovieByIDShouldReturnError: Bool = false
    var fetchMoviesByListShouldReturnError: Bool = false
    var fetchMoviesByGenreShouldReturnError: Bool = false
    var clearMoviesForListShouldReturnError: Bool = false
    var removeMovieFromListShouldReturnError: Bool = false
    
    var stubbedMovies: [MockMovie] = []

    // MARK: - MovieRepositoryProtocol
    func storeMovieForList(_ movie: MovieProtocol, provider: String, listType: String, orderIndex: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        didCallstoreMovieForList = true
        capturedMovie = movie
        capturedProvider = provider
        capturedListType = listType
        capturedOrderIndex = orderIndex
        
        if storeMovieForListShouldReturnError {
            completion(.failure(NSError(domain: "storeMovieForList Error", code: 0, userInfo: nil)))
        } else {
            completion(.success(Void()))
        }
    }
    
    func storeMoviesForList(_ movies: [MovieProtocol], provider: String, listType: String, completion: @escaping (Result<Void, Error>) -> Void) {
        didCallStoreMoviesForList = true
        capturedMovies = movies
        capturedProvider = provider
        capturedListType = listType
        
        if storeMoviesForListShouldReturnError {
            completion(.failure(NSError(domain: "storeMoviesForList Error", code: 0, userInfo: nil)))
        } else {
            completion(.success(Void()))
        }
    }
    
    func fetchMovieByID(_ id: Int, provider: String, listType: String) throws -> MovieProtocol? {
        didCallFetchMovieByID = true
        capturedMovieID = id
        capturedProvider = provider
        capturedListType = listType
        
        if fetchMovieByIDShouldReturnError {
            throw NSError(domain: "fetchMovieByID Error", code: 0, userInfo: nil)
        } else {
            return MockMovie()
        }
    }
    
    func fetchMoviesByList(provider: String, listType: String) throws -> [MovieProtocol] {
        didCallFetchMoviesByList = true
        capturedProvider = provider
        capturedListType = listType
        
        if fetchMoviesByListShouldReturnError {
            throw NSError(domain: "fetchMoviesByList Error", code: 0, userInfo: nil)
        } else {
            return stubbedMovies
        }
    }
    
    func fetchMoviesByGenre(genre: GenreProtocol, provider: String, listType: String) throws -> [MovieProtocol] {
        didCallFetchMoviesByGenre = true
        capturedGenre = genre
        capturedProvider = provider
        capturedListType = listType
        
        if fetchMoviesByGenreShouldReturnError {
            throw NSError(domain: "fetchMoviesByGenre Error", code: 0, userInfo: nil)
        } else {
            return stubbedMovies
        }
    }
    
    func clearMoviesForList(provider: String, listName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        didCallClearMoviesForList = true
        capturedProvider = provider
        capturedListType = listName
        
        if clearMoviesForListShouldReturnError {
            completion(.failure(NSError(domain: "clearMoviesForList Error", code: 0, userInfo: nil)))
        } else {
            completion(.success(Void()))
        }
    }
    
    func removeMovieFromList(_ movieID: Int, provider: String, listName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        didCallRemoveMovieFromList = true
        capturedMovieID = movieID
        capturedProvider = provider
        capturedListType = listName
        
        if removeMovieFromListShouldReturnError {
            completion(.failure(NSError(domain: "removeMovieFromList Error", code: 0, userInfo: nil)))
        } else {
            completion(.success(Void()))
        }
    }
    
}
