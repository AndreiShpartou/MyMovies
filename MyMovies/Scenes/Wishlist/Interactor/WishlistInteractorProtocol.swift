//
//  WishlistInteractorProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol WishlistInteractorProtocol: AnyObject {
    var presenter: WishlistInteractorOutputProtocol? { get set }

    func fetchWishlist()
}

protocol WishlistInteractorOutputProtocol: AnyObject {
    func didFetchWishlist(_ movies: [MovieProtocol])
    func didFailToFetchData(error: Error)
}
