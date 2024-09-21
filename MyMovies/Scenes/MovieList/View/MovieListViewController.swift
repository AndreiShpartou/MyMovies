//
//  MovieListViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

final class MovieListViewController: UIViewController {
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
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        // Setting the custom title font
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: Typography.SemiBold.title,
            NSAttributedString.Key.foregroundColor: UIColor.textColorWhite
        ]
        // Custom left button
        navigationItem.leftBarButtonItem = createCustomLeftBarButton()
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

// MARK: - Helpers
extension MovieListViewController {
    private func createCustomLeftBarButton() -> UIBarButtonItem {
        let leftButton = UIButton(type: .custom)
        leftButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        leftButton.tintColor = .white
        leftButton.backgroundColor = .primarySoft
        leftButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.layer.cornerRadius = 15

        let leftBarButton = UIBarButtonItem(customView: leftButton)

        return leftBarButton
    }
}

// MARK: - MovieListViewDelegate
extension MovieListViewController: MovieListViewInteractionDelegate {
    func didSelectGenre(_ genre: GenreViewModelProtocol) {
        presenter?.didSelectGenre(genre)
    }

    func didSelectMovie(movieID: Int) {
        presenter?.didSelectMovie(movieID: movieID)
    }
}
