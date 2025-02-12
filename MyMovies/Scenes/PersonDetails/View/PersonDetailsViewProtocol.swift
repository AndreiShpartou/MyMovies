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
    func showPersonMovies(_ movies: [BriefMovieListItemViewModelProtocol])
    func showLoading()
    func hideLoading()
    func showError(error: Error)
}

protocol PersonDetailsViewDelegate: AnyObject, BriefMovieDescriptionHandlerDelegate {
    func didTapSeeAllButton(listType: MovieListType)
    func didSelectMovie(movieID: Int)
}
