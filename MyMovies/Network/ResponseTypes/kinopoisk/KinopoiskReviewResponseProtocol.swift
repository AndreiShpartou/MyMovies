//
//  KinopoiskReviewResponseProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/10/2024.
//

import Foundation

protocol KinopoiskReviewResponseProtocol: PagedResponseResultProtocol {
    var author: String { get }
    var review: String { get }
}
