//
//  MovieDetailsViewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import UIKit

protocol MovieDetailsViewProtocol: UIView {
    var delegate: MovieDetailsInteractionDelegate? { get set }
    var presenter: MovieDetailsPresenterProtocol? { get set }

    func showDetailedMovie(_ movie: MovieDetailsViewModelProtocol)
    func showMovieReviews(_ reviews: [ReviewViewModelProtocol])
    func showSimilarMovies(_ movies: [BriefMovieListItemViewModelProtocol])
}

protocol MovieDetailsInteractionDelegate: AnyObject {
    func didFetchTitle(_ title: String?)
}
