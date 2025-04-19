//
//  TMDBPersonsPagedResponse.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 17/12/2024.
//

import Foundation

struct TMDBPersonsPagedResponse: TMDBPagedResponseProtocol {
    var page: Int
    var results: [TMDBPersonResponse]
    var total_pages: Int
    var total_results: Int
}
