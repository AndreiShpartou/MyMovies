//
//  TMDBReviewResponseProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/10/2024.
//

import Foundation

protocol TMDBReviewResponseProtocol: PagedResponseResultProtocol {
    var author: String { get }
    var content: String { get }
}
