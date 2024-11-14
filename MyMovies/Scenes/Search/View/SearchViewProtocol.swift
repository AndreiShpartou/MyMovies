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
    func showUpcomingMovie(_ movie: UpcomingMovieViewModelProtocol)
    func showRecentlySearchedMovies(_ movies: [BriefMovieListItemViewModelProtocol])
    func showPopularMovies(_ movies: [BriefMovieListItemViewModelProtocol])
    func showSearchResults(_ movies: [BriefMovieListItemViewModelProtocol])
    func showActorResults(_ actors: [ActorViewModelProtocol], relatedMovies: [BriefMovieListItemViewModelProtocol])
    func showNoResults()
    func hideAllElements()
    func showInitialElements()
    func showLoading()
    func hideLoading()
    func showError(error: Error)
}

protocol SearchViewDelegate: AnyObject, UISearchBarDelegate {
    func didSearch(query: String)
    func didSelectGenre(_ genre: GenreViewModelProtocol)
    func didSelectMovie(movieID: Int)
    func didSelectActor(actorID: Int)
    func didTapSeeAllButton()
}
