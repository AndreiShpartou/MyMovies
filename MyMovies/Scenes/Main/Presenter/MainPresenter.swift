//
//  MainPresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    var view: MainViewProtocol? { get set }
    var interactor: MainInteractorProtocol { get set }
    var router: MainRouterProtocol { get set }

    func viewDidLoad()
    func didFetchMovies(_ movies: [Movie])
    func didFetchCategories(_ categories: [Category])
    func didSelectMovie(_ movie: Movie)
}

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

    func didFetchCategories(_ categories: [Category]) {
        //
    }

    func didSelectMovie(_ movie: Movie) {
        //
    }
}
