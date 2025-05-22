//
//  MockNetworkService.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 16/04/2025.
//

import Foundation
@testable import MyMovies

// MARK: - MockNetworkService
final class MockNetworkService: NetworkServiceProtocol {
    var didCallFetchMovies: Bool = false
    var didCallFetchMovieDetails: Bool = false
    var didCallFetchMoviesDetails: Bool = false
    var didCallFetchMoviesDetailsByID: Bool = false
    var didCallFetchPersonDetails: Bool = false
    var didCallFetchPersonRelatedMovies: Bool = false
    var didCallFetchMoviesByGenre: Bool = false
    var didCallFetchGenres: Bool = false
    var didCallFetchReviews: Bool = false
    var didCallSearchMovies: Bool = false
    var didCallSearchPersons: Bool = false
    var didCallGetProvider: Bool = false
    
    var capturedMovieListType: MovieListType?
    var capturedMovie: MovieProtocol?
    var capturedMovies: [MovieProtocol]?
    var capturedMoviesIDs: [Int]?
    var capturedPersonID: Int?
    var capturedGenre: GenreProtocol?
    var capturedReviews: [MovieReview]?
    var capturedMovieID: Int?
    var capturedSearchMoviesQuery: String?
    var capturedSearchPersonsQuery: String?
    
    var fetchMoviesShouldReturnError: Bool = false
    var fetchMovieDetailsShouldReturnError: Bool = false
    var fetchMoviesDetailsShouldReturnError: Bool = false
    var fetchMoviesDetailsByIDShouldReturnError: Bool = false
    var fetchMoviesByGenreShouldReturnError: Bool = false
    var fetchPersonDetailsShouldReturnError: Bool = false
    var fetchPersonRelatedMoviesShouldReturnError: Bool = false
    var fetchReviewsShouldReturnError: Bool = false
    var fetchGenresShouldReturnError: Bool = false
    var fetchSearchMoviesShouldReturnError: Bool = false
    var fetchSearchPersonsShouldReturnError: Bool = false
    
    var stubbedGenres: [GenreProtocol] = []
    var stubbedMovies: [MovieProtocol] = []
    var stubbedReviews: [MovieReview] = []

    // MARK: - NetworkServiceProtocol
    // MARK: - Movies
    func fetchMovies<T: MovieProtocol>(type: MovieListType, completion: @escaping (Result<[T], Error>) -> Void) {
        didCallFetchMovies = true
        capturedMovieListType = type
        
        if fetchMoviesShouldReturnError {
            completion(.failure(NSError(domain: "fetchMovies Error", code: 0, userInfo: nil)))
        } else {
            completion(.success(stubbedMovies as! [T]))
        }
    }
    
    func fetchMovieDetails<T: MovieProtocol>(for movie: T, type: MovieListType, completion: @escaping (Result<T, Error>) -> Void) {
        didCallFetchMovieDetails = true
        capturedMovie = movie
        capturedMovieListType = type
        
        if fetchMovieDetailsShouldReturnError {
            completion(.failure(NSError(domain: "fetchMovieDetails Error", code: 0, userInfo: nil)))
        } else {
            completion(.success(movie))
        }
    }
    
    func fetchMoviesDetails<T: MovieProtocol>(for movies: [T], type: MovieListType, completion: @escaping ([T]) -> Void) {
        didCallFetchMoviesDetails = true
        capturedMovies = movies
        capturedMovieListType = type
        
        completion(stubbedMovies as! [T])
    }
    
    func fetchMoviesDetails<T: MovieProtocol>(for ids: [Int], defaultValue: [T], completion: @escaping (Result<[T], Error>) -> Void) {
        didCallFetchMoviesDetailsByID = true
        capturedMoviesIDs = ids
        
        if fetchMoviesDetailsByIDShouldReturnError {
            completion(.failure(NSError(domain: "fetchMoviesDetailsByID Error", code: 0, userInfo: nil)))
        } else {
            completion(.success(stubbedMovies as! [T]))
        }
    }
    
    func fetchMoviesByGenre<T: GenreProtocol, Y: MovieProtocol>(type: MovieListType, genre: T, completion: @escaping (Result<[Y], Error>) -> Void) {
        didCallFetchMoviesByGenre = true
        capturedGenre = genre
        capturedMovieListType = type
        
        if fetchMoviesByGenreShouldReturnError {
            completion(.failure(NSError(domain: "fetchMoviesByGenre Error", code: 0, userInfo: nil)))
        } else {
            completion(.success(stubbedMovies as! [Y]))
        }
    }
    
    // MARK: - PersonDetails
    func fetchPersonDetails(for personID: Int, completion: @escaping (Result<PersonDetailed, Error>) -> Void) {
        didCallFetchPersonDetails = true
        capturedPersonID = personID
        
        if fetchPersonDetailsShouldReturnError {
            completion(.failure(NSError(domain: "fetchPersonDetails Error", code: 0, userInfo: nil)))
        } else {
            completion(.success(PersonDetailed(id: 0, name: "MockPersonDetailed")))
        }
    }
    
    func fetchPersonRelatedMovies<T: MovieProtocol>(for personID: Int, completion: @escaping (Result<[T], Error>) -> Void) {
        didCallFetchPersonRelatedMovies = true
        capturedPersonID = personID
        
        if fetchPersonRelatedMoviesShouldReturnError {
            completion(.failure(NSError(domain: "fetchPersonRelatedMovies Error", code: 0, userInfo: nil)))
        } else {
            completion(.success(stubbedMovies as! [T]))
        }
    }
    
    // MARK: - Genres
    func fetchGenres<T: GenreProtocol>(completion: @escaping (Result<[T], Error>) -> Void) {
        didCallFetchGenres = true
        
        if fetchGenresShouldReturnError {
            completion(.failure(NSError(domain: "fetchGenres Error", code: 0, userInfo: nil)))
        } else {
            completion(.success(stubbedGenres))
        }
        
    }
    
    // MARK: - Other
    func fetchReviews(for movieID: Int, completion: @escaping (Result<[MovieReview], Error>) -> Void) {
        didCallFetchReviews = true
        capturedMovieID = movieID
        
        if fetchReviewsShouldReturnError {
            completion(.failure(NSError(domain: "fetchReviews Error", code: 0, userInfo: nil)))
        } else {
            completion(.success(stubbedReviews))
        }
    }

    func searchMovies<T: MovieProtocol>(query: String, completion: @escaping (Result<[T], Error>) -> Void) {
        didCallSearchMovies = true
        capturedSearchMoviesQuery = query
        
        if fetchSearchMoviesShouldReturnError {
            completion(.failure(NSError(domain: "fetchSearchMovies Error", code: 0, userInfo: nil)))
        } else {
            completion(.success(stubbedMovies as! [T]))
        }
    }
    
    func searchPersons<T: PersonProtocol>(query: String, completion: @escaping (Result<[T], Error>) -> Void) {
        didCallSearchPersons = true
        capturedSearchPersonsQuery = query
        
        if fetchSearchPersonsShouldReturnError {
            completion(.failure(NSError(domain: "fetchSearchPersons Error", code: 0, userInfo: nil)))
        } else {
            completion(.success([MockPerson() as! T]))
        }
    }
    
    func getProvider() -> Provider {
        didCallGetProvider = true

        return .kinopoisk
    }
    
    // MARK: - Stubs
    func fetchSettingsSections(completion: @escaping (Result<[ProfileSettingsSection], Error>) -> Void) {
    }
    
}
