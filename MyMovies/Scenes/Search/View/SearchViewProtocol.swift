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
    func showUpcomingMovie(_ movie: MovieListItemViewModelProtocol)
    func showRecentlySearchedMovies(_ movies: [BriefMovieListItemViewModelProtocol])
    func showSearchResults(_ movies: [BriefMovieListItemViewModelProtocol])
    func showPersonResults(_ persons: [PersonViewModelProtocol], relatedMovies: [BriefMovieListItemViewModelProtocol])
    func showNoResults()
    func hideAllElements()
    func showInitialElements()
    func showLoading()
    func hideLoading()
    func showError(error: Error)
}

protocol SearchViewDelegate: AnyObject, UISearchBarDelegate, GenresCollectionViewDelegate, BriefMovieDescriptionHandlerDelegate, MovieListCollectionViewDelegate {
    func didSearch(query: String)
    func didSelectGenre(_ genre: GenreViewModelProtocol)
    func didSelectMovie(movieID: Int)
    func didSelectPerson(personID: Int)
    func didTapSeeAllButton()
}
