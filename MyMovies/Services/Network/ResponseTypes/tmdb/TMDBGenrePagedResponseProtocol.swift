//
//  TMDBGenrePagedResponseProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 21/08/2024.
//

import Foundation

protocol TMDBGenrePagedResponseProtocol: Codable {
    var genres: [TMDBGenreResponse] { get }
}
