//
//  KinopoiskMovieResponseProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 21/08/2024.
//

import Foundation

protocol KinopoiskMovieResponseProtocol: PagedResponseResultProtocol {
    var id: Int { get }
    var name: String { get }
    var alternativeName: String? { get }
    var enName: String? { get }
    var type: String { get }
    var year: Int { get }
    var description: String? { get }
    var shortDescription: String? { get }
    var movieLength: Int? { get }
    var poster: KinopoiskCoverResponseProtocol? { get }
    var backdrop: KinopoiskCoverResponseProtocol? { get }
    var genres: [KinopoiskGenreResponseProtocol] { get }
    var rating: KinopoiskRatingResponseProtocol? { get }
}

protocol KinopoiskGenreResponseProtocol: Codable {
    var name: String { get }
}

protocol KinopoiskRatingResponseProtocol: Codable {
    var kp: Float? { get }
}

protocol KinopoiskCoverResponseProtocol: Codable {
    var url: String? { get }
    var previewUrl: String? { get }
}
