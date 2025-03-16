//
//  WishlistPresenterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol WishlistPresenterProtocol: AnyObject {
    var view: WishlistViewProtocol? { get set }
    var interactor: WishlistInteractorProtocol { get set }
    var router: WishlistRouterProtocol { get set }

    func viewDidLoad()
    func didSelectMovie(movieID: Int)
}
