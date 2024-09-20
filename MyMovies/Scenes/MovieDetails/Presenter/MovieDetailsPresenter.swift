//
//  MovieDetailsPresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

class MovieDetailsPresenter: MovieDetailsPresenterProtocol {
    weak var view: MovieDetailsViewProtocol?
    var interactor: MovieDetailsInteractorProtocol
    var router: MovieDetailsRouterProtocol

    // MARK: - Init
    init(view: MovieDetailsViewProtocol, interactor: MovieDetailsInteractorProtocol, router: MovieDetailsRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}
