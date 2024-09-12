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

    func showUpcomingMovies(_ movies: [MovieProtocol])
    func scrollToUpcomingMovieItem(_ index: Int)
    func showPopularMovies(_ movies: [MovieProtocol])
    func showMovieGenres(_ genres: [GenreProtocol])
    func showError(error: Error)
}

protocol MainViewDelegate: AnyObject {
    func didSelectMovie(_ movie: MovieProtocol)
    func didSelectGenre(_ genre: GenreProtocol)
    func didTapSeeAllUpcomingMoviesButton()
    func didTapSeeAllPopularMoviesButton()
    func didScrollUpcomingMoviesItemTo(_ index: Int)
}
