//
//  SearchViewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import UIKit

protocol SearchViewProtocol: UIView {
    var delegate: SearchViewDelegate? { get set }

    func showGenres(_ genres: [GenreViewModelProtocol])
    func showUpcomingMovies(_ movie: [MovieListItemViewModelProtocol])
    func showRecentlySearchedMovies(_ movies: [BriefMovieListItemViewModelProtocol])
    func showMoviesSearchResults(_ movies: [MovieListItemViewModelProtocol])
    func showPersonsSearchResults(_ persons: [PersonViewModelProtocol])
    func showNoResults()
    func hideAllElements()
    func setInitialElements(isHidden: Bool)
    func setLoadingIndicator(for section: MainAppSection, isVisible: Bool)
    func setNilValueForScrollOffset()
    func showError(with message: String)
}

protocol SearchViewDelegate: AnyObject, UISearchBarDelegate, GenresCollectionViewDelegate, BriefMovieDescriptionHandlerDelegate, MovieListCollectionViewDelegate, PersonsCollectionViewDelegate {
    func didTapSeeAllButton(listType: MovieListType)
}
