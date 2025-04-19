//
//  TMDBMovieResponseProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 21/08/2024.
//

import Foundation

protocol TMDBMovieResponseProtocol: PagedResponseResultProtocol {
    var id: Int { get }
    var title: String { get }
    var originalTitle: String? { get }
    var overview: String? { get }
    var status: String? { get }
    var tagline: String? { get }
    var releaseDate: String? { get }
    var runtime: Int? { get }
    var voteAverage: Double? { get }
    var genreIds: [Int]? { get }
    var genres: [TMDBGenreResponseProtocol]? { get }
    var countries: [TMDBCountryResponseProtocol]? { get }
    var credits: TMDBCreditsResponseProtocol? { get }
    var posterPath: String? { get }
    var backdropPath: String? { get }

    func posterURL(size: PosterSize) -> String?
    func backdropURL(size: BackdropSize) -> String?
}

protocol TMDBGenreResponseProtocol: Codable {
    var id: Int { get }
    var name: String? { get }
}

protocol TMDBCountryResponseProtocol: Codable {
    var iso_3166_1: String { get }
    var name: String { get }
}

protocol TMDBCreditsResponseProtocol: Codable {
    var cast: [TMDBPersonResponseProtocol]? { get }
    var crew: [TMDBPersonResponseProtocol]? { get }
}
