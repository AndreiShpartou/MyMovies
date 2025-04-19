//
//  KinopoiskPersonsPagedResponse.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 17/12/2024.
//

import Foundation

struct KinopoiskPersonsPagedResponse: KinopoiskPagedResponseProtocol {
    var docs: [KinopoiskPersonResponse]
    var total: Int
    var limit: Int
    var page: Int
    var pages: Int
}
