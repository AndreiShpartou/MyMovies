//
//  NetworkManagerProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/09/2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchMovies(type: MovieListType, completion: @escaping (Result<[MovieProtocol], Error>) -> Void)
    func fetchMovieDetails(for movie: MovieProtocol, completion: @escaping (Result<MovieProtocol, Error>) -> Void)
    func fetchMoviesDetails(for movies: [MovieProtocol], completion: @escaping ([MovieProtocol]) -> Void)
    func fetchMoviesByGenre(type: MovieListType, genre: GenreProtocol, completion: @escaping (Result<[MovieProtocol], Error>) -> Void)
    func fetchGenres(completion: @escaping (Result<[GenreProtocol], Error>) -> Void)
}
