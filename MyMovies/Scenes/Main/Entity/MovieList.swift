//
//  MovieList.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 03/08/2024.
//

import Foundation

struct MovieList: Codable {
    let id: Int
    let name: String
    let adult: Bool
    let original_name: String
    let original_language: String
    let overview: String
    let poster_path: String
    let backdrop_path: String

    func posterURL(size: PosterSize = .w154) -> URL? {
        return ImageURLBuilder.buildURL(for: poster_path, size: size)
    }

    func backdropURL(size: BackdropSize = .w300) -> URL? {
        return ImageURLBuilder.buildURL(for: backdrop_path, size: size)
    }
}
