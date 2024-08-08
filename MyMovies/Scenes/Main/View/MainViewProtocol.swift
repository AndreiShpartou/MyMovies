//
//  MainViewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import UIKit

protocol MainViewProtocol: UIView, AnyObject {
    var presenter: MainPresenterProtocol? { get set }
    var delegate: MainViewDelegate? { get set }

    func showMovieLists(movieLists: [MovieList])
    func showMovieCategories(categories: [Category])
    func showPopularMovies(movies: [Movie])
    func showError(error: Error)
}

protocol MainViewDelegate: AnyObject {
    func didSelectMovieList(_ movieList: MovieList)
    func didSelectCategory(_ category: Category)
    func didSelectMovie(_ movie: Movie)
    func didTapSeeAllCategoriesButton()
    func didTapSeeAllPopularMoviesButton()
}
