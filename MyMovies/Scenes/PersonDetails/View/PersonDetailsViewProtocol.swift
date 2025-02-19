//
//  PersonDetailsViewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 11/02/2025.
//

import UIKit

protocol PersonDetailsViewProtocol: UIView {
    var delegate: PersonDetailsViewDelegate? { get set }

    func showPersonDetails(_ person: PersonDetailedViewModelProtocol)
    func showMovieGenres(_ genres: [GenreViewModelProtocol])
    func showPersonRelatedMovies(_ movies: [BriefMovieListItemViewModelProtocol])
    func showLoading()
    func hideLoading()
    func showError(_ error: Error)
}

protocol PersonDetailsViewDelegate: AnyObject, BriefMovieDescriptionHandlerDelegate, GenresCollectionViewDelegate {
    func didTapSeeAllButton()
    func didSelectGenre(_ genre: GenreViewModelProtocol)
    func didSelectMovie(movieID: Int)
}
