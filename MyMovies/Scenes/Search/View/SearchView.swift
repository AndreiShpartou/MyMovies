//
//  SearchView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

final class SearchView: UIView, SearchViewProtocol {
    weak var delegate: SearchViewDelegate?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - SearchViewProtocol
    func showGenres(_ genres: [GenreViewModelProtocol]) {
        //
    }

    func showUpcomingMovie(_ movie: UpcomingMovieViewModelProtocol) {
        //
    }

    func showRecentlySearchedMovies(_ movies: [BriefMovieListItemViewModelProtocol]) {
        //
    }

    func showPopularMovies(_ movies: [BriefMovieListItemViewModelProtocol]) {
        //
    }

    func showSearchResults(_ movies: [BriefMovieListItemViewModelProtocol]) {
        //
    }

    func showActorResults(_ actors: [ActorViewModelProtocol], relatedMovies: [BriefMovieListItemViewModelProtocol]) {
        //
    }

    func showNoResults() {
        //
    }

    func hideAllElements() {
        //
    }

    func showInitialElements() {
        //
    }

    func showLoading() {
        //
    }

    func hideLoading() {
        //
    }

    func showError(error: Error) {
        //
    }
}

// MARK: - Setup
extension SearchView {
    private func setupView() {
        backgroundColor = .primaryBackground
    }
}

// MARK: - Constraints
extension SearchView {
    private func setupConstraints() {
    }
}
