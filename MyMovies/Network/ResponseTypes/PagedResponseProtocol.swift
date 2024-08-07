//
//  PagedResponseProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 07/08/2024.
//

import Foundation

protocol PagedResponseProtocol: Codable {
    associatedtype ResultType: Codable
    var docs: [ResultType] { get }
    var total: Int { get }
    var limit: Int { get }
    var page: Int { get }
    var pages: Int { get }
}
