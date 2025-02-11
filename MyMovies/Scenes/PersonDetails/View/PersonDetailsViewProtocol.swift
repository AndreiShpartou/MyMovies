//
//  PersonDetailsViewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 11/02/2025.
//

import UIKit

protocol PersonDetailsViewProtocol: UIView {
    var delegate: PersonDetailsViewDelegate? { get set }

    func showPersonDetails(_ person: PersonDetailsViewModelProtocol)
    func showPersonMovies(_ movies: [BriefMovieListItemViewModelProtocol])
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showError(error: Error)
}

protocol PersonDetailsViewDelegate: AnyObject {
    func didFetchTitle(_ title: String?)
    func didTapSeeAllButton(listType: MovieListType)
    func didSelectMovie(movieID: Int)
}
