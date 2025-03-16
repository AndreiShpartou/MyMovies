//
//  MainViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

protocol MainViewControllerProtocol {
    var presenter: MainPresenterProtocol { get set }
}

final class MainViewController: UIViewController, MainViewControllerProtocol {
    var presenter: MainPresenterProtocol

    private let mainView: MainViewProtocol

    // MARK: - Init
    init(mainView: MainViewProtocol, presenter: MainPresenterProtocol) {
        self.mainView = mainView
        self.presenter = presenter

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
        // The initial data loading
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = true
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
    func didSelectGenre(_ genre: GenreViewModelProtocol) {
        // Handle genre selection
        presenter.didSelectGenre(genre)
    }

    func didSelectMovie(movieID: Int) {
        // Handle popular movie selection
        presenter.didSelectMovie(movieID: movieID)
    }

    func didTapSeeAllButton(listType: MovieListType) {
        presenter.didTapSeeAllButton(listType: listType)
    }

    func didScrollUpcomingMoviesItemTo(_ index: Int) {
        mainView.scrollToUpcomingMovieItem(index)
    }
}
