//
//  WishlistItemViewModelProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 17/03/2025.
//

import Foundation

protocol WishlistItemViewModelProtocol {
    var id: Int { get }
    var title: String { get }
    var posterURL: URL? { get }
    var genre: String { get }
    var voteAverage: String { get }
}
