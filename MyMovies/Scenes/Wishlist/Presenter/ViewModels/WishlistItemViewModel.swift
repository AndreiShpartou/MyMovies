//
//  WishlistItemViewModel.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 17/03/2025.
//

import Foundation

struct WishlistItemViewModel: WishlistItemViewModelProtocol {
    let id: Int
    let title: String
    var posterURL: URL?
    let genre: String
    let voteAverage: String
}
