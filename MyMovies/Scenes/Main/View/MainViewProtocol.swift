//
//  MainViewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import UIKit

protocol MainViewProtocol: UIView {
    var delegate: MainViewDelegate? { get set }

    func showUpcomingMovies(_ movies: [UpcomingMovieViewModelProtocol])
    func scrollToUpcomingMovieItem(_ index: Int)
    func showPopularMovies(_ movies: [BriefMovieListItemViewModelProtocol])
    func showMovieGenres(_ genres: [GenreViewModelProtocol])
    func showError(error: Error)
}

protocol MainViewDelegate: AnyObject, GenresCollectionViewDelegate, BriefMovieDescriptionHandlerDelegate, UpcomingMoviesCollectionViewDelegate {
    func didSelectMovie(movieID: Int)
    func didSelectGenre(_ genre: GenreViewModelProtocol)
    func didTapSeeAllButton(listType: MovieListType)
    func didScrollUpcomingMoviesItemTo(_ index: Int)
}
