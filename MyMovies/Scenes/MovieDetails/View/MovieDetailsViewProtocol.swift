//
//  MovieDetailsViewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import UIKit

protocol MovieDetailsViewProtocol: UIView {
    var delegate: MovieDetailsViewDelegate? { get set }

    func showDetailedMovie(_ movie: MovieDetailsViewModelProtocol)
    func showMovieReviews(_ reviews: [ReviewViewModelProtocol])
    func showSimilarMovies(_ movies: [BriefMovieListItemViewModelProtocol])
    func showError(with message: String)
}

protocol MovieDetailsViewDelegate: AnyObject, BriefMovieDescriptionHandlerDelegate, PersonCollectionViewHandlerDelegate {
    func didFetchTitle(_ title: String?)
    func didSelectReview(_ author: String?, review: String?)
    func didTapSeeAllButton(listType: MovieListType)
    func updateFavouriteButtonState(isSelected: Bool)
}
