//
//  WishlistInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

protocol WishlistInteractorProtocol: AnyObject {
}

class WishlistInteractor: WishlistInteractorProtocol {
    weak var presenter: WishlistPresenterProtocol?
}
