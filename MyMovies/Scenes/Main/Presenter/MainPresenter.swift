//
//  MainPresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

final class MainPresenter: MainPresenterProtocol {
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
//        interactor.fetchMovieLists()
//        interactor.fetchMovieCategories()
        interactor.fetchTopMovies()
    }
}

extension MainPresenter: MainInteractorOutputProtocol {

    func didFetchMovieLists(_ movieLists: [MovieList]) {
        // Update the view with the fetched data
        view?.showMovieLists(movieLists: movieLists)
    }

    func didFetchMovieCategories(_ movieCategories: [MovieCategory]) {
        //
    }

    func didFetchTopMovies(_ movies: [Movie]) {
        //
    }

    func didFailToFetchData(with error: Error) {
        // Handle error
        view?.showError(error: error)
    }
}
