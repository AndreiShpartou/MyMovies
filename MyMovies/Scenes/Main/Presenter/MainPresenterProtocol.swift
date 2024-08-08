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
    func didSelectCategory(_ category: Category)
    func didSelectMovie(_ movie: Movie)
    func didTapAllCategoriesButton()
    func didTapSeeAllPopularMoviesButton()
}
