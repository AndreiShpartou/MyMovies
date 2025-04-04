//
//  WishlistViewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import UIKit

protocol WishlistViewProtocol: UIView {
    var delegate: WishlistViewDelegate? { get set }

    func showMovies(_ movies: [WishlistItemViewModelProtocol])
    func removeMovie(at index: Int)
    func setLoadingIndicator(isVisible: Bool)
    func showError(with message: String)
}

protocol WishlistViewDelegate: AnyObject, WishlistCollectionViewHandlerDelegate {
    func didSelectMovie(movieID: Int)
}
