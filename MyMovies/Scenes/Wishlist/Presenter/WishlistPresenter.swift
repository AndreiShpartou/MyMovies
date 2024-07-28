//
//  WishlistPresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

protocol WishlistPresenterProtocol: AnyObject {
}

class WishlistPresenter: WishlistPresenterProtocol {
    weak var view: WishlistViewProtocol?
    var interactor: WishlistInteractorProtocol?
    var router: WishlistRouterProtocol?
}
