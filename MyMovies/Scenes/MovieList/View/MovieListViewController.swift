//
//  MovieListViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

protocol MovieListViewCOntrollerProtocol {
    var presenter: MovieListPresenterProtocol { get set }
}

final class MovieListViewController: UIViewController {
    var presenter: MovieListPresenterProtocol

    private let movieListView: MovieListViewProtocol
    private let movieListType: MovieListType

    init(movieListView: MovieListViewProtocol, presenter: MovieListPresenterProtocol, listType: MovieListType) {
        self.movieListView = movieListView
        self.presenter = presenter
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
        presenter.viewDidLoad(listType: movieListType)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationBar()
    }
}

// MARK: - Setup
extension MovieListViewController {
    private func setupViewController() {
        movieListView.delegate = self
    }

    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        title = movieListType.title
        // Setting the custom title font
        navigationController?.navigationBar.titleTextAttributes = getNavigationBarTitleAttributes()
        // Custom left button
        navigationItem.leftBarButtonItem = .createCustomBackBarButtonItem(action: #selector(backButtonTapped), target: self)
    }
}

// MARK: - ActionMethods
extension MovieListViewController {
    @objc
    private func backButtonTapped(_ sender: UIButton) {
        // Handle back button action
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - MovieListViewDelegate
extension MovieListViewController: MovieListViewInteractionDelegate {
    func didSelectGenre(_ genre: GenreViewModelProtocol) {
        presenter.didSelectGenre(genre)
    }

    func didSelectMovie(movieID: Int) {
        presenter.didSelectMovie(movieID: movieID)
    }
}
