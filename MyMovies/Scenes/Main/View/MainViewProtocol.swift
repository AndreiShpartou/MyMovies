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
    func showMovieGenres(genres: [GenreProtocol])
    func showPopularMovies(movies: [Movie])
    func showError(error: Error)
}

protocol MainViewDelegate: AnyObject {
    func didSelectMovieList(_ movieList: MovieList)
    func didSelectGenre(_ genre: GenreProtocol)
    func didSelectMovie(_ movie: Movie)
    func didTapSeeAllMovieListsButton()
    func didTapSeeAllPopularMoviesButton()
}
