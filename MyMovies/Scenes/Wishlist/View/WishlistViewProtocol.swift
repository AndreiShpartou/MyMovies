//
//  WishlistViewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import UIKit

protocol WishlistViewProtocol: UIView {
    var delegate: WishlistViewDelegate? { get set }

    func showMovies()
    func showError(error: Error)
}

protocol WishlistViewDelegate: AnyObject {
    func didSelectMovie(movieID: Int)
}
