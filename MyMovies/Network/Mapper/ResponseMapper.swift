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
        // reviews
        case (is TMDBReviewsPagedResponse.Type, is [MovieReview].Type):
            return map(data as! TMDBReviewsPagedResponse) as! T
        case (is KinopoiskReviewsPagedResponse.Type, is [MovieReview].Type):
            return map(data as! KinopoiskReviewsPagedResponse) as! T
        default:
            throw NetworkError.unsupportedMappingTypes
        }
    }

    // MARK: - Movies
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
                status: $0.status,
                releaseYear: $0.releaseDate,
                runtime: String($0.runtime ?? 0),
                voteAverage: ($0.voteAverage == 0) ? Double.random(in: 5.0...7.0) : $0.voteAverage,
                genres: map($0.genreIds ?? []),
                countries: map($0.countries ?? []),
                persons: [],
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
        let persons: [TMDBPersonResponseProtocol] = (data.credits?.cast ?? []) + (data.credits?.crew ?? [])

        return Movie(
            id: data.id,
            title: data.title,
            alternativeTitle: data.originalTitle,
            description: data.overview,
            shortDescription: data.tagline,
            status: data.status,
            releaseYear: data.releaseDate,
            runtime: String(data.runtime ?? 0),
            voteAverage: (data.voteAverage == 0) ? Double.random(in: 5.0...7.0) : data.voteAverage,
            genres: map(data.genres ?? []),
            countries: map(data.countries ?? []),
            persons: map(persons),
            poster: poster,
            backdrop: backdrop
        )
    }

    private func map(_ data: KinopoiskMoviesPagedResponse) -> [Movie] {
        return data.docs.map {
            Movie(
                id: $0.id,
                title: $0.name ?? $0.alternativeName ?? "",
                alternativeTitle: $0.alternativeName,
                description: $0.description,
                shortDescription: $0.shortDescription,
                status: $0.status,
                releaseYear: String($0.year ?? Calendar.current.component(.year, from: Date())),
                runtime: String($0.movieLength ?? 0),
                voteAverage: ($0.rating?.kp == 0) ? Double.random(in: 5.0...7.0) : $0.rating?.kp,
                genres: map($0.genres ?? []),
                countries: map($0.countries),
                persons: map($0.persons ?? []),
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

    // MARK: - Genres
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

    private func map(_ data: [TMDBGenreResponseProtocol]) -> [Movie.Genre] {
        return data.map {
            Movie.Genre(id: $0.id, name: $0.name)
        }
    }

    // MARK: - Countries
    private func map(_ data: [TMDBCountryResponseProtocol]) -> [Movie.ProductionCountry] {
        return data.map {
            Movie.ProductionCountry(name: $0.iso_3166_1, fullName: $0.name)
        }
    }

    private func map(_ data: [KinopoiskCountryResponseProtocol]) -> [Movie.ProductionCountry] {
        return data.map {
            Movie.ProductionCountry(name: $0.name, fullName: $0.name)
        }
    }

    // MARK: - Persons
    private func map(_ data: [TMDBPersonResponseProtocol]) -> [Movie.Person] {
        let persons = data.map {
            Movie.Person(
                id: $0.id,
                photo: $0.personPhotoURL(path: $0.profile_path, size: .w185),
                name: $0.name,
                originalName: $0.original_name,
                profession: $0.known_for_department
            )
        }

        return removeDuplicates(from: persons)
    }

    private func map(_ data: [KinopoiskPersonResponseProtocol]) -> [Movie.Person] {
        let persons: [Movie.Person] = data.compactMap {
            guard let id = $0.id, let name = $0.name else {
                return nil
            }

            return Movie.Person(
                id: id,
                photo: $0.photo,
                name: name,
                originalName: $0.enName,
                profession: $0.profession
            )
        }

        return removeDuplicates(from: persons)
    }

    // MARK: - Reviews
    private func map(_ data: TMDBReviewsPagedResponse) -> [MovieReview] {
        return data.results.map {
            MovieReview(author: $0.author, review: $0.content)
        }
    }

    private func map(_ data: KinopoiskReviewsPagedResponse) -> [MovieReview] {
        return data.docs.map {
            MovieReview(author: $0.author, review: $0.review)
        }
    }
}

// MARK: - Helpers
extension ResponseMapper {
    private func removeDuplicates(from persons: [Movie.Person]) -> [Movie.Person] {
        var seenIDs = Set<Int>()
        var uniquePersons = [Movie.Person]()

        for person in persons where !seenIDs.contains(person.id) {
            seenIDs.insert(person.id)
            uniquePersons.append(person)
        }

        return uniquePersons
    }
}
