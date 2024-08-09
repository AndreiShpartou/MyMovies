//
//  MainPresenterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    var view: MainViewProtocol? { get set }
    var interactor: MainInteractorProtocol { get set }
    var router: MainRouterProtocol { get set }

    func viewDidLoad()
    func didSelectMovieList(_ movieList: MovieList)
    func didSelectGenre(_ genre: Genre)
    func didSelectMovie(_ movie: Movie)
    func didTapAllMovieListsButton()
    func didTapSeeAllPopularMoviesButton()
}
