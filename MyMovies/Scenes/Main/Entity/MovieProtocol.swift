//
//  MovieProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 20/08/2024.
//

import Foundation

protocol MovieProtocol {
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

protocol GenreProtocol {
    var id: Int? { get }
    var name: String { get }
    var slug: String? { get }
}

protocol CoverProtocol {
    var url: String? { get }
    var previewUrl: String? { get }
}
