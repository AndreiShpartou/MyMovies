//
//  TMDBMovieResponse.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 21/08/2024.
//

import Foundation

struct TMDBMovieResponse: TMDBMovieResponseProtocol {
    var id: Int
    var title: String
    var originalTitle: String?
    var overview: String?
    var status: String?
    var tagline: String?
    var releaseDate: String?
    var runtime: Int?
    var voteAverage: Double?
    var posterPath: String?
    var backdropPath: String?
    var genreIds: [Int]?
    var genres: [TMDBGenreResponseProtocol]? {
        return movieGenres
    }
    var countries: [TMDBCountryResponseProtocol]? {
        return movieCountries
    }
    var credits: TMDBCreditsResponseProtocol? {
        return movieCredits
    }

    private let movieGenres: [TMDBMovieResponse.Genre]?
    private let movieCountries: [TMDBMovieResponse.Country]?
    private let movieCredits: TMDBMovieResponse.Credits?

    struct Genre: TMDBGenreResponseProtocol {
        var id: Int
        var name: String?
    }

    struct Country: TMDBCountryResponseProtocol {
        var iso_3166_1: String
        var name: String
    }

    struct Credits: TMDBCreditsResponseProtocol {
        var cast: [TMDBPersonResponseProtocol]? {
            return movieCast
        }
        var crew: [TMDBPersonResponseProtocol]? {
            return movieCrew
        }

        private let movieCast: [Person]?
        private let movieCrew: [Person]?

        struct Person: TMDBPersonResponseProtocol {
            var id: Int
            var name: String
            var original_name: String
            var profile_path: String?
            var known_for_department: String?

            func personPhotoURL(path: String?, size: PersonSize = .w185) -> String? {
                guard let path = path else {
                    return nil
                }

                return ImageURLBuilder.buildURL(for: path, size: size)
            }
        }

        enum CodingKeys: String, CodingKey {
            case movieCast = "cast"
            case movieCrew = "crew"
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, tagline, status
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case movieGenres = "genres"
        case movieCountries = "production_countries"
        case movieCredits = "credits"
    }

    // MARK: - Public
    func posterURL(size: PosterSize = .w780) -> String? {
        guard let posterPath = posterPath else {
            return nil
        }

        return ImageURLBuilder.buildURL(for: posterPath, size: size)
    }

    func backdropURL(size: BackdropSize = .w780) -> String? {
        guard let backdropPath = backdropPath else {
            return nil
        }

        return ImageURLBuilder.buildURL(for: backdropPath, size: size)
    }
}
