//
//  TMDBReviewsPagedResponse.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/10/2024.
//

import Foundation

struct TMDBReviewsPagedResponse: TMDBPagedResponseProtocol {
    var page: Int
    var results: [TMDBReviewResponse]
    var total_pages: Int
    var total_results: Int
}
