//
//  MovieListPresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

class MovieListPresenter: MovieListPresenterProtocol {
    weak var view: MovieListViewProtocol?
    var interactor: MovieListInteractorProtocol
    var router: MovieListRouterProtocol

    private let mapper: DomainModelMapperProtocol

    // MARK: - Init
    init(
        view: MovieListViewProtocol? = nil,
        interactor: MovieListInteractorProtocol,
        router: MovieListRouterProtocol,
        mapper: DomainModelMapperProtocol = DomainModelMapper()
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.mapper = mapper
    }

    func viewDidLoad(listType: MovieListType) {
        interactor.fetchMovieGenres()
        interactor.fetchMovieList(type: listType)
    }

    func didSelectGenre(_ genre: GenreViewModelProtocol) {
        guard let movieGenre = mapper.map(data: genre, to: Movie.Genre.self) else {
            return
        }

        interactor.fetchMovieListWithGenresFiltering(genre: movieGenre)
    }
}

// MARK: - MovieListInteractorOutputProtocol
extension MovieListPresenter: MovieListInteractorOutputProtocol {
    func didFetchMovieGenres(_ genres: [GenreProtocol]) {
        // Map to ViewModel
        guard let genreViewModels: [GenreViewModel] = mapper.map(data: genres, to: [GenreViewModel].self) else {
            return
        }

        view?.showMovieGenres(genreViewModels)
    }

    func didFetchMovieList(_ movies: [MovieProtocol]) {
        view?.showMovieList(movies)
    }

    func didFailToFetchData(with error: Error) {
        //
    }
}
