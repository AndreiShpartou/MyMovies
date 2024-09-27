//
//  MovieProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 20/08/2024.
//

import Foundation

protocol MovieProtocol: Codable {
    var id: Int { get }
    var title: String { get }
    var alternativeTitle: String? { get }
    var description: String? { get }
    var shortDescription: String? { get }
    var status: String? { get }
    var releaseYear: String? { get }
    var runtime: String? { get }
    var voteAverage: Double? { get }
    var genres: [GenreProtocol] { get }
    var countries: [CountryProtocol] { get }
    var persons: [PersonProtocol] { get }
    var poster: CoverProtocol? { get }
    var backdrop: CoverProtocol? { get }
}

protocol GenreProtocol: Codable {
    var id: Int? { get }
    var name: String? { get }
    var rawName: String? { get }
}

protocol CoverProtocol: Codable {
    var url: String? { get }
    var previewUrl: String? { get }
}

protocol CountryProtocol: Codable {
    var name: String { get }
}

protocol PersonProtocol: Codable {
    var id: Int { get }
    var photo: String? { get }
    var name: String { get }
    var originalName: String? { get }
    var profession: String? { get }
}
