//
//  KinopoiskMovieResponseProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 21/08/2024.
//

import Foundation

protocol KinopoiskMovieResponseProtocol: PagedResponseResultProtocol {
    var id: Int { get }
    var name: String? { get }
    var alternativeName: String? { get }
    var enName: String? { get }
    var type: String? { get }
    var year: Int? { get }
    var description: String? { get }
    var shortDescription: String? { get }
    var slogan: String? { get }
    var status: String? { get set }
    var movieLength: Int? { get }
    var poster: KinopoiskCoverResponse? { get }
    var backdrop: KinopoiskCoverResponse? { get }
    var genres: [KinopoiskGenreResponse]? { get }
    var countries: [KinopoiskCountryResponse]? { get }
    var persons: [KinopoiskPersonResponse]? { get }
    var rating: KinopoiskRatingResponse? { get }
    var similarMovies: [KinopoiskMovieResponse]? { get }
}

protocol KinopoiskGenreResponseProtocol: Codable {
    var name: String { get }
}

protocol KinopoiskCountryResponseProtocol: Codable {
    var name: String { get }
}

protocol KinopoiskRatingResponseProtocol: Codable {
    var kp: Double? { get }
}

protocol KinopoiskCoverResponseProtocol: Codable {
    var url: String? { get }
    var previewUrl: String? { get }
}
