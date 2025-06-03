//
//  MainViewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import UIKit

protocol MainViewProtocol: UIView {
    var delegate: MainViewDelegate? { get set }

    func showUpcomingMovies(_ movies: [UpcomingMovieViewModelProtocol])
    func scrollToUpcomingMovieItem(_ index: Int)
    func showPopularMovies(_ movies: [BriefMovieListItemViewModelProtocol])
    func showTopRatedMovies(_ movies: [BriefMovieListItemViewModelProtocol])
    func showTheHighestGrossingMovies(_ movies: [BriefMovieListItemViewModelProtocol])
    func showMovieGenres(_ genres: [GenreViewModelProtocol])
    func showUserProfile(_ user: UserProfileViewModelProtocol)
    func didLogOut()
    func setLoadingIndicator(for section: MainAppSection, isVisible: Bool)
    func setNilValueForScrollOffset()
    func showError(with messsage: String)
}

protocol MainViewDelegate: AnyObject, GenresCollectionViewDelegate, BriefMovieDescriptionHandlerDelegate, UpcomingMoviesCollectionViewDelegate, UserGreetingViewDelegate, UISearchBarDelegate {
    func didTapSeeAllButton(listType: MovieListType)
}
