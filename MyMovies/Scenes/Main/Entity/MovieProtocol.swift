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
    var description: String { get }
    var releaseYear: String? { get }
    var runtime: String? { get }
    var voteAverage: Float? { get }
    var genres: [GenreProtocol] { get }
    var poster: CoverProtocol? { get }
    var backdrop: CoverProtocol? { get }
}

protocol GenreProtocol: Codable {
    var id: Int? { get }
    var name: String { get }
}

protocol CoverProtocol: Codable {
    var url: String? { get }
    var previewUrl: String? { get }
}
