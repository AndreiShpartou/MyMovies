//
//  MovieListViewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import UIKit

protocol MovieListViewProtocol: UIView {
    var delegate: MovieListViewInteractionDelegate? { get set }

    func showMovieGenres(_ genres: [GenreViewModelProtocol])
    func showMovieList(_ movies: [MovieListItemViewModelProtocol])
}

protocol MovieListViewInteractionDelegate: AnyObject, GenresCollectionViewDelegate, MovieListCollectionViewDelegate {
    func didSelectGenre(_ genre: GenreViewModelProtocol)
    func didSelectMovie(movieID: Int)
}
