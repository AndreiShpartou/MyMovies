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
    var capturedGenreID: Int?
    var capturedGenre: GenreProtocol?
    var capturedReviews: [MovieReviewProtocol]?
    var capturedMovieID: Int?
    var capturedSearchMoviesQuery: String?
    var capturedSearchPersonsQuery: String?
    
    var fetchMoviesShouldReturnError: Bool = false
    var fetchMovieDetailsShouldReturnError: Bool = false
    var fetchMoviesDetailsByIDShouldReturnError: Bool = false
    var fetchMoviesByGenreShouldReturnError: Bool = false
    var fetchPersonDetailsShouldReturnError: Bool = false
    var fetchPersonRelatedMoviesShouldReturnError: Bool = false
    var fetchReviewsShouldReturnError: Bool = false
    var fetchGenresShouldReturnError: Bool = false
    var fetchSearchMoviesShouldReturnError: Bool = false
    var fetchSearchPersonsShouldReturnError: Bool = false

    // MARK: - NetworkServiceProtocol
    // MARK: - Movies
    func fetchMovies(type: MovieListType, completion: @escaping (Result<[MovieProtocol], Error>) -> Void) {
        didCallFetchMovies = true
        capturedMovieListType = type
        
        if fetchMoviesShouldReturnError {
            completion(.failure(NSError(domain: "fetchMovies Error", code: 0, userInfo: nil)))
        } else {
            completion(.success([MockMovie()]))
        }
    }
    
    func fetchMovieDetails(for movie: MovieProtocol, type: MovieListType, completion: @escaping (Result<MovieProtocol, Error>) -> Void) {
        didCallFetchMovieDetails = true
        capturedMovie = movie
        capturedMovieListType = type
        
        if fetchMovieDetailsShouldReturnError {
            completion(.failure(NSError(domain: "fetchMovieDetails Error", code: 0, userInfo: nil)))
        } else {
            completion(.success(MockMovie()))
        }
    }
    
    func fetchMoviesDetails(for movies: [MovieProtocol], type: MovieListType, completion: @escaping ([MovieProtocol]) -> Void) {
        didCallFetchMoviesDetails = true
        capturedMovies = movies
        capturedMovieListType = type
        
        completion([MockMovie()])
    }
    
    func fetchMoviesDetails(for ids: [Int], defaultValue: [MovieProtocol], completion: @escaping (Result<[MovieProtocol], Error>) -> Void) {
        didCallFetchMoviesDetailsByID = true
        capturedMoviesIDs = ids
        
        if fetchMoviesDetailsByIDShouldReturnError {
            completion(.failure(NSError(domain: "fetchMoviesDetailsByID Error", code: 0, userInfo: nil)))
        } else {
            completion(.success([MockMovie()]))
        }
    }
    
    func fetchMoviesByGenre(type: MovieListType, genre: GenreProtocol, completion: @escaping (Result<[MovieProtocol], Error>) -> Void) {
        didCallFetchMoviesByGenre = true
        capturedGenre = genre
        capturedMovieListType = type
        
        if fetchMoviesByGenreShouldReturnError {
            completion(.failure(NSError(domain: "fetchMoviesByGenre Error", code: 0, userInfo: nil)))
        } else {
            completion(.success([MockMovie()]))
        }
    }
    
    // MARK: - PersonDetails
    func fetchPersonDetails(for personID: Int, completion: @escaping (Result<PersonDetailedProtocol, Error>) -> Void) {
        didCallFetchPersonDetails = true
        capturedPersonID = personID
        
        if fetchPersonDetailsShouldReturnError {
            completion(.failure(NSError(domain: "fetchPersonDetails Error", code: 0, userInfo: nil)))
        } else {
            completion(.success(MockPersonDetailed()))
        }
    }
    
    func fetchPersonRelatedMovies(for personID: Int, completion: @escaping (Result<[MovieProtocol], Error>) -> Void) {
        didCallFetchPersonRelatedMovies = true
        capturedPersonID = personID
        
        if fetchPersonRelatedMoviesShouldReturnError {
            completion(.failure(NSError(domain: "fetchPersonRelatedMovies Error", code: 0, userInfo: nil)))
        } else {
            completion(.success([MockMovie()]))
        }
    }
    
    // MARK: - Genres
    func fetchGenres(completion: @escaping (Result<[GenreProtocol], Error>) -> Void) {
        didCallFetchGenres = true
        
        if fetchGenresShouldReturnError {
            completion(.failure(NSError(domain: "fetchGenres Error", code: 0, userInfo: nil)))
        } else {
            completion(.success([MockMovie.Genre()]))
        }
        
    }
    
    // MARK: - Other
    func fetchReviews(for movieID: Int, completion: @escaping (Result<[MovieReviewProtocol], Error>) -> Void) {
        didCallFetchReviews = true
        capturedMovieID = movieID
        
        if fetchReviewsShouldReturnError {
            completion(.failure(NSError(domain: "fetchReviews Error", code: 0, userInfo: nil)))
        } else {
            completion(.success([MockReview()]))
        }
    }

    func searchMovies(query: String, completion: @escaping (Result<[MovieProtocol], Error>) -> Void) {
        didCallSearchMovies = true
        capturedSearchMoviesQuery = query
        
        if fetchSearchMoviesShouldReturnError {
            completion(.failure(NSError(domain: "fetchSearchMovies Error", code: 0, userInfo: nil)))
        } else {
            completion(.success([MockMovie()]))
        }
    }
    
    func searchPersons(query: String, completion: @escaping (Result<[PersonProtocol], Error>) -> Void) {
        didCallSearchPersons = true
        capturedSearchPersonsQuery = query
        
        if fetchSearchPersonsShouldReturnError {
            completion(.failure(NSError(domain: "fetchSearchPersons Error", code: 0, userInfo: nil)))
        } else {
            completion(.success([MockMovie.Person()]))
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
