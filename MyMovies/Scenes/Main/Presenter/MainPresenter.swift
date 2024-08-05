//
//  MainPresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    var interactor: MainInteractorProtocol
    var router: MainRouterProtocol

    // MARK: - Init
    init(view: MainViewProtocol?, interactor: MainInteractorProtocol, router: MainRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        //
    }

    func didFetchMovies(_ movies: [Movie]) {
        //
    }

    func didFetchCategories(_ categories: [Genre]) {
        //
    }

    func didSelectMovie(_ movie: Movie) {
        //
    }
}
