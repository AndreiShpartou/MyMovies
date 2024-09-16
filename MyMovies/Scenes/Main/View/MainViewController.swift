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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
        // The initial data loading
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

    func didSelectGenre(_ genre: GenreProtocol) {
        // Handle genre selection
        presenter?.didSelectGenre(genre)
    }

    func didSelectMovie(_ movie: MovieProtocol) {
        // Handle popular movie selection
        presenter?.didSelectMovie(movie)
    }

    func didTapSeeAllButton(listType: MovieListType) {
        presenter?.didTapSeeAllButton(listType: listType)
    }

    func didScrollUpcomingMoviesItemTo(_ index: Int) {
        mainView.scrollToUpcomingMovieItem(index)
    }
}
