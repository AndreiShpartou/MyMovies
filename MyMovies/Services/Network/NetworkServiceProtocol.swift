//
//  NetworkServiceProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/09/2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchMovies<T: MovieProtocol>(type: MovieListType, completion: @escaping (Result<[T], Error>) -> Void)
    func fetchMovieDetails<T: MovieProtocol>(for movie: T, type: MovieListType, completion: @escaping (Result<T, Error>) -> Void)
    func fetchMoviesDetails<T: MovieProtocol>(for movies: [T], type: MovieListType, completion: @escaping ([T]) -> Void)
    // Get movie details by array of id (single request for all movies)
    func fetchMoviesDetails<T: MovieProtocol>(for ids: [Int], defaultValue: [T], completion: @escaping (Result<[T], Error>) -> Void)
    func fetchPersonDetails(for personID: Int, completion: @escaping (Result<PersonDetailed, Error>) -> Void)
    func fetchPersonRelatedMovies<T: MovieProtocol>(for personID: Int, completion: @escaping (Result<[T], Error>) -> Void)
    func fetchMoviesByGenre<T: GenreProtocol, Y: MovieProtocol>(type: MovieListType, genre: T, completion: @escaping (Result<[Y], Error>) -> Void)
    func fetchGenres<T: GenreProtocol>(completion: @escaping (Result<[T], Error>) -> Void)
    func fetchReviews(for movieID: Int, completion: @escaping (Result<[MovieReview], Error>) -> Void)
    func fetchSettingsSections(completion: @escaping (Result<[ProfileSettingsSection], Error>) -> Void)
    // Search
    func searchMovies<T: MovieProtocol>(query: String, completion: @escaping (Result<[T], Error>) -> Void)
    func searchPersons<T: PersonProtocol>(query: String, completion: @escaping (Result<[T], Error>) -> Void)
    // Provider
    func getProvider() -> Provider
}
