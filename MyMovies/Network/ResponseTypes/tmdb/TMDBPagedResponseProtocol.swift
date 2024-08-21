//
//  TMDBPagedResponseProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 07/08/2024.
//

import Foundation

protocol TMDBPagedResponseProtocol: Codable {
    associatedtype ResultType: PagedResponseResultProtocol
    var page: Int { get }
    var results: [ResultType] { get }
    var total_pages: Int { get }
    var total_results: Int { get }
}
