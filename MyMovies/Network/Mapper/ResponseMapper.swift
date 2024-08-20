//
//  ResponseMapper.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 20/08/2024.
//

import Foundation

final class ResponseMapper: ResponseMapperProtocol {
    func map<T: Codable>(data: Codable, from responseType: Codable.Type, to entityType: T.Type) throws -> T {
        switch (responseType, entityType) {
        case (let fromType, let toType) where fromType == toType:
            return data as! T
        // genres
        case (is TMDBGenresResponse.Type, is [GenreProtocol].Type):
            return map(data as! TMDBGenresResponse) as! T
        default:
            throw NetworkError.unsupportedMappingTypes
        }
    }

    // Genres
    private func map(_ data: TMDBGenresResponse) -> [GenreProtocol] {
        return data.genres
    }

//    // Example mapping from TMDB
//    func mapFromTMDBResponse(_ response: TMDBMovieResponse) -> UnifiedMovie {
//        return UnifiedMovie(
//            id: response.id,
//            title: response.title,
//            alternativeTitle: response.originalTitle,
//            genres: response.genres.map { UnifiedGenreProtocol(id: $0.id, name: $0.name) },
//            overview: response.overview,
//            posterUrl: response.posterPath,
//            backdropUrl: response.backdropPath,
//            releaseDate: response.releaseDate,
//            runtime: response.runtime,
//            rating: UnifiedMovie.Rating(kp: nil, imdb: response.voteAverage, tmdb: response.voteAverage, filmCritics: nil, russianFilmCritics: nil, await: nil),
//            language: response.originalLanguage,
//            status: response.status,
//            voteAverage: response.voteAverage,
//            voteCount: response.voteCount
//        )
//    }
//
//    // Example mapping from Kinopoisk
//    func mapFromKinopoiskResponse(_ response: KinopoiskMovieResponse) -> UnifiedMovie {
//        return UnifiedMovie(
//            id: response.id,
//            title: response.name,
//            alternativeTitle: response.alternativeName,
//            genres: response.genres.map { UnifiedGenreProtocol(id: nil, name: $0.name) },
//            overview: response.description ?? "",
//            posterUrl: response.poster?.url,
//            backdropUrl: response.backdrop?.url,
//            releaseDate: response.premiere?.world,
//            runtime: response.movieLength,
//            rating: UnifiedMovie.Rating(kp: response.rating?.kp, imdb: response.rating?.imdb, tmdb: response.rating?.tmdb, filmCritics: response.rating?.filmCritics, russianFilmCritics: response.rating?.russianFilmCritics, await: response.rating?.await),
//            language: response.enName,
//            status: response.status,
//            voteAverage: response.rating?.kp,
//            voteCount: response.votes?.kp
//        )
//    }
}
