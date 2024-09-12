//
//  KinopoiskMoviesPagedResponse.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 20/08/2024.
//

import Foundation

struct KinopoiskMoviesPagedResponse: KinopoiskPagedResponseProtocol {
    var docs: [KinopoiskMovieResponse]
    var total: Int
    var limit: Int
    var page: Int
    var pages: Int
}
