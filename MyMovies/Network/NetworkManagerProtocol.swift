//
//  NetworkManagerProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/09/2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchMovies(type: MovieListType, completion: @escaping (Result<[MovieProtocol], Error>) -> Void)
    func fetchMovieDetails(for movie: MovieProtocol, type: MovieListType, completion: @escaping (Result<MovieProtocol, Error>) -> Void)
    func fetchMoviesDetails(for movies: [MovieProtocol], type: MovieListType, completion: @escaping ([MovieProtocol]) -> Void)
    func fetchMoviesByGenre(type: MovieListType, genre: GenreProtocol, completion: @escaping (Result<[MovieProtocol], Error>) -> Void)
    func fetchMovieByPerson(person: PersonProtocol, completion: @escaping (Result<[MovieProtocol], Error>) -> Void)
    func fetchGenres(completion: @escaping (Result<[GenreProtocol], Error>) -> Void)
    func fetchReviews(for movieID: Int, completion: @escaping (Result<[MovieReviewProtocol], Error>) -> Void)
    func fetchUserProfile(completion: @escaping (Result<UserProfileProtocol, Error>) -> Void)
    func fetchSettingsSections(completion: @escaping (Result<[ProfileSettingsSection], Error>) -> Void)
    // Search
    func searchMovies(query: String, completion: @escaping (Result<[MovieProtocol], Error>) -> Void)
    func searchPersons(query: String, completion: @escaping (Result<[PersonProtocol], Error>) -> Void)
}
