//
//  WishlistPresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

class WishlistPresenter: WishlistPresenterProtocol {
    weak var view: WishlistViewProtocol?
    var interactor: WishlistInteractorProtocol
    var router: WishlistRouterProtocol

    // MARK: - Init
    init(view: WishlistViewProtocol? = nil, interactor: WishlistInteractorProtocol, router: WishlistRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    // MARK: - Public
    func viewDidLoad() {
        //
    }

    func didSelectMovie(movieID: Int) {
        //
    }
}

extension WishlistPresenter: WishlistInteractorOutputProtocol {
    func didFetchWishlist(_ movies: [MovieProtocol]) {
    }

    func didFailToFetchData(error: Error) {
    }
}
