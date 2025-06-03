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
    func setLoadingIndicator(for section: MainAppSection, isVisible: Bool)
    func showError(with message: String)
}

protocol PersonDetailsViewDelegate: AnyObject, BriefMovieDescriptionHandlerDelegate, GenresCollectionViewDelegate {
    func didTapSeeAllButton()
}
