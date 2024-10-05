//
//  KinopoiskReviewsPagedResponse.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/10/2024.
//

import Foundation

struct KinopoiskReviewsPagedResponse: KinopoiskPagedResponseProtocol {
    var docs: [KinopoiskReviewResponse]
    var total: Int
    var limit: Int
    var page: Int
    var pages: Int
}
