//
//  NetworkServiceProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/09/2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchMovies(type: MovieListType, completion: @escaping (Result<[MovieProtocol], Error>) -> Void)
    func fetchMovieDetails(for movie: MovieProtocol, type: MovieListType, completion: @escaping (Result<MovieProtocol, Error>) -> Void)
    func fetchMoviesDetails(for movies: [MovieProtocol], type: MovieListType, completion: @escaping ([MovieProtocol]) -> Void)
    // Get movie details by array of id (single request for all movies)
    func fetchMoviesDetails(for ids: [Int], defaultValue: [MovieProtocol], completion: @escaping (Result<[MovieProtocol], Error>) -> Void)
    func fetchPersonDetails(for personID: Int, completion: @escaping (Result<PersonDetailedProtocol, Error>) -> Void)
    func fetchPersonRelatedMovies(for personID: Int, completion: @escaping (Result<[MovieProtocol], Error>) -> Void)
    func fetchMoviesByGenre(type: MovieListType, genre: GenreProtocol, completion: @escaping (Result<[MovieProtocol], Error>) -> Void)
    func fetchGenres(completion: @escaping (Result<[GenreProtocol], Error>) -> Void)
    func fetchReviews(for movieID: Int, completion: @escaping (Result<[MovieReviewProtocol], Error>) -> Void)
    func fetchSettingsSections(completion: @escaping (Result<[ProfileSettingsSection], Error>) -> Void)
    // Search
    func searchMovies(query: String, completion: @escaping (Result<[MovieProtocol], Error>) -> Void)
    func searchPersons(query: String, completion: @escaping (Result<[PersonProtocol], Error>) -> Void)
    // Provider
    func getProvider() -> Provider
}
