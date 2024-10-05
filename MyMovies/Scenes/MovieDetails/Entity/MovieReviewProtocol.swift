//
//  MovieReviewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/10/2024.
//

import Foundation

protocol MovieReviewProtocol: Codable {
    var author: String { get }
    var review: String { get }
}
