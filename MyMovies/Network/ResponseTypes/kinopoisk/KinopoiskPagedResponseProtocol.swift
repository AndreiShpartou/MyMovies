//
//  KinopoiskPagedResponseProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 20/08/2024.
//

import Foundation

protocol KinopoiskPagedResponseProtocol: Codable {
    associatedtype ResultType: PagedResponseResultProtocol
    var docs: [ResultType] { get }
    var total: Int { get }
    var limit: Int { get }
    var page: Int { get }
    var pages: Int { get }
}
