//
//  MovieListType.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 03/08/2024.
//

import Foundation

// kinopoisk movie collections slug
// popular-films - Популярные фильмы (category - Фильмы)
// the_closest_releases - Ближайшие премьеры (category - Онлайн-кинотеатр)
// hd-must-see - Фильмы, которые стоит посмотреть (category - Онлайн-кинотеатр)
// top20of2023 - Топ-20 фильмов и сериалов 2023 года (category - Онлайн-кинотеатр)
// top10-hd - Топ 10 в онлайн-кинотеатре (category - Онлайн-кинотеатр)
// planned-to-watch-films - Рейтинг ожидаемых фильмов (category - Фильмы)
// top500 - 500 лучших фильмов (category - Фильмы)
// top250 - 250 лучших фильмов (category - Фильмы)

enum MovieListType {
    // Get a list of movies that are being released soon.
    case upcomingMovies
    // Get a list of movies ordered by popularity
    case popularMovies
    // Get a list of the current top rated movies
    case topRatedMovies
    // Get a list of the highest-grossing movies. By default, this list will only include movies that have a box office revenue value.
    case theHighestGrossingMovies
    // Get a list of similar movies
    case similarMovies(id: Int)
    // Get a list of searched movies
    case searchedMovies(query: String)
    // Get a list of person related movies
    case personRelatedMovies(id: Int)

    var endpoint: Endpoint {
        return .movieList(type: self)
    }

    var title: String {
        switch self {
        case .upcomingMovies:
            return "Upcoming Movies"
        case .popularMovies:
            return "Popular Movies"
        case .topRatedMovies:
            return "Top Rated Movies"
        case .theHighestGrossingMovies:
            return "The Highest Grossing Movies"
        case .similarMovies:
            return "Similar Movies"
        case .searchedMovies:
            return "Discovered Movies"
        case .personRelatedMovies:
            return "Person Related Movies"
        }
    }

    var rawValue: String {
        switch self {
        case .upcomingMovies:
            return "upcomingMovies"
        case .popularMovies:
            return "popularMovies"
        case .topRatedMovies:
            return "topRatedMovies"
        case .theHighestGrossingMovies:
            return "theHighestGrossingMovies"
        case .similarMovies:
            return "similarMovies"
        case .searchedMovies:
            return "searchMovies"
        case .personRelatedMovies:
            return "personRelatedMovies"
        }
    }
}
