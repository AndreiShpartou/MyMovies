//
//  MainViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

final class MainViewController: UIViewController {
    var presenter: MainPresenterProtocol?

    private let mainView: MainViewProtocol

    // MARK: - Init
    init(mainView: MainViewProtocol) {
        self.mainView = mainView

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        presenter?.viewDidLoad()
    }
}

// MARK: - Setup
extension MainViewController {
    private func setupViewController() {
        mainView.delegate = self
    }
}

// MARK: - MainViewDelegate
extension MainViewController: MainViewDelegate {
    func didSelectMovieList(_ movieList: MovieList) {
        // Handle movie list selection
        presenter?.didSelectMovieList(movieList)
    }

    func didSelectGenre(_ genre: Genre) {
        // Handle genre selection
        presenter?.didSelectGenre(genre)
    }

    func didSelectMovie(_ movie: Movie) {
        // Handle popular movie selection
        presenter?.didSelectMovie(movie)
    }

    func didTapSeeAllMovieListsButton() {
        // Handle "See All" action for movie list
        presenter?.didTapAllMovieListsButton()
    }

    func didTapSeeAllPopularMoviesButton() {
        // Handle "See All" action for popular movies
        presenter?.didTapSeeAllPopularMoviesButton()
    }
}
