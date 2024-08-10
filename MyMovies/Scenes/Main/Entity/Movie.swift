//
//  Movie.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 29/07/2024.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let name: String
    let enName: String?
    let type: String
    let year: Int
    let description: String?
    let shortDescription: String?
    let rating: Rating
    let poster: Cover
    let backdrop: Cover?
    let genres: [Genre]
}

struct Rating: Codable {
    let kp: Float
    let imdb: Float
}

struct Cover: Codable {
    let url: String
    let previewUrl: String
}

struct Genre: Codable {
    let id: Int
    let name: String
    let slug: String
}
