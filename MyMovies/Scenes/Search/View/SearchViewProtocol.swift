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
    func showInitialElements()
    func showLoading()
    func hideLoading()
    func showError(_ error: Error)
}

protocol SearchViewDelegate: AnyObject, UISearchBarDelegate, GenresCollectionViewDelegate, BriefMovieDescriptionHandlerDelegate, MovieListCollectionViewDelegate, PersonsCollectionViewDelegate {
    func didSelectGenre(_ genre: GenreViewModelProtocol)
    func didSelectMovie(movieID: Int)
    func didSelectPerson(personID: Int)
    func didTapSeeAllButton(listType: MovieListType)
}
