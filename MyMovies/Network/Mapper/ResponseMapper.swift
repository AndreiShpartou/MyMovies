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
        // movies
        case ( is TMDBMoviesPagedResponse.Type, is [Movie].Type):
            return map(data as! TMDBMoviesPagedResponse) as! T
        case ( is KinopoiskMoviesPagedResponse.Type, is [Movie].Type):
            return map(data as! KinopoiskMoviesPagedResponse) as! T
        case (is TMDBMovieResponse.Type, is Movie.Type):
            return map(data as! TMDBMovieResponse) as! T
        // genres
        case (is TMDBGenrePagedResponse.Type, is [Movie.Genre].Type):
            return map(data as! TMDBGenrePagedResponse) as! T
        case (is [KinopoiskMovieResponse.Genre].Type, is [Movie.Genre].Type):
            return map(data as! [KinopoiskMovieResponse.Genre]) as! T
        default:
            throw NetworkError.unsupportedMappingTypes
        }
    }

    // Movies
    private func map(_ data: TMDBMoviesPagedResponse) -> [Movie] {
        return data.results.map {
            let poster = Movie.Cover(
                url: $0.posterURL(size: .original),
                previewUrl: $0.posterURL(size: .w780)
            )
            let backdrop = Movie.Cover(
                url: $0.backdropURL(size: .original),
                previewUrl: $0.backdropURL(size: .w780)
            )

            return Movie(
                id: $0.id,
                title: $0.title,
                alternativeTitle: $0.originalTitle,
                description: $0.overview,
                shortDescription: $0.tagline,
                releaseYear: $0.releaseDate,
                runtime: String($0.runtime ?? 0),
                voteAverage: $0.voteAverage,
                genres: map($0.genreIds ?? []),
                poster: poster,
                backdrop: backdrop
            )
        }
    }

    private func map(_ data: TMDBMovieResponse) -> Movie {
        let poster = Movie.Cover(
            url: data.posterURL(size: .original),
            previewUrl: data.posterURL(size: .w780)
        )
        let backdrop = Movie.Cover(
            url: data.backdropURL(size: .original),
            previewUrl: data.backdropURL(size: .w780)
        )

        return Movie(
            id: data.id,
            title: data.title,
            alternativeTitle: data.originalTitle,
            description: data.overview,
            shortDescription: data.tagline,
            releaseYear: data.releaseDate,
            runtime: String(data.runtime ?? 0),
            voteAverage: data.voteAverage,
            genres: map(data.genreIds ?? []),
            poster: poster,
            backdrop: backdrop
        )
    }

    private func map(_ data: KinopoiskMoviesPagedResponse) -> [Movie] {
        return data.docs.map {
            Movie(
                id: $0.id,
                title: $0.name,
                alternativeTitle: $0.alternativeName,
                description: $0.description,
                shortDescription: $0.shortDescription,
                releaseYear: String($0.year),
                runtime: String($0.movieLength ?? 0),
                voteAverage: $0.rating?.kp,
                genres: map($0.genres),
                poster: Movie.Cover(
                    url: $0.poster?.url,
                    previewUrl: $0.poster?.previewUrl
                ),
                backdrop: Movie.Cover(
                    url: $0.backdrop?.url,
                    previewUrl: $0.backdrop?.previewUrl
                )
            )
        }
    }

    // Genres
    private func map(_ data: TMDBGenrePagedResponseProtocol) -> [Movie.Genre] {
        return data.genres.map {
            return Movie.Genre(id: $0.id, name: $0.name)
        }
    }

    private func map(_ data: [KinopoiskGenreResponseProtocol]) -> [Movie.Genre] {
        return data.map {
            return Movie.Genre(name: $0.name)
        }
    }

    private func map(_ data: [Int]) -> [Movie.Genre] {
        return data.map {
            return Movie.Genre(id: $0, name: nil)
        }
    }
}
