//
//  MovieListViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

class MovieListViewController: UIViewController {
    var presenter: MovieListPresenterProtocol?

    private let movieListView: MovieListViewProtocol
    private let movieListType: MovieListType

    init(movieListView: MovieListViewProtocol, listType: MovieListType) {
        self.movieListView = movieListView
        self.movieListType = listType

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func loadView() {
        view = movieListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
        // The initial data loading
        presenter?.viewDidLoad(listType: movieListType)
    }
}

// MARK: - Setup
extension MovieListViewController {
    private func setupViewController() {
        movieListView.delegate = self
    }
}

// MARK: - MovieListViewDelegate
extension MovieListViewController: MovieListViewDelegate {
    func didSelectGenre(_ genre: GenreProtocol) {
        presenter?.didSelectGenre(genre)
    }
}
